package com.miser.moneyTracker.user

import org.springframework.security.access.AccessDeniedException
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.oauth2.jwt.Jwt
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken
import org.springframework.stereotype.Service
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.support.TransactionTemplate

/**
 * Resolves the local user for the Keycloak access token on the current
 * request, creating the user row on first sign-in. Provisioning runs in its
 * own write transaction so it also works when called from read-only services.
 */
@Service
class CurrentUserService(
    private val userRepository: UserRepository,
    transactionManager: PlatformTransactionManager,
) {
    private val provisioning = TransactionTemplate(transactionManager).apply {
        propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
    }

    fun getCurrentUserId(): Long = getCurrentUser().id

    fun getCurrentUser(): User {
        val jwt = currentJwt()
        return userRepository.findByExternalId(jwt.subject).orElseGet { provision(jwt) }
    }

    private fun currentJwt(): Jwt {
        val auth = SecurityContextHolder.getContext().authentication as? JwtAuthenticationToken
            ?: throw AccessDeniedException("Not authenticated")
        // A missing subject must never reach findByExternalId: Spring Data turns a
        // null argument into "IS NULL" and would match legacy users without an identity.
        if (auth.token.subject.isNullOrBlank()) throw AccessDeniedException("Token has no subject")
        return auth.token
    }

    private fun provision(jwt: Jwt): User = provisioning.execute {
        userRepository.findByExternalId(jwt.subject).orElse(null)?.let { return@execute it }

        val email = jwt.getClaimAsString("email")
            ?: throw AccessDeniedException("Identity token has no email claim")
        val existing = userRepository.findByEmail(email).orElse(null)
        if (existing != null) {
            // Link a pre-existing local account only when the IdP vouches for the email.
            if (existing.externalId != null || jwt.getClaimAsBoolean("email_verified") != true) {
                throw AccessDeniedException("Email is already linked to another sign-in")
            }
            existing.externalId = jwt.subject
            return@execute userRepository.save(existing)
        }
        userRepository.save(
            User.builder()
                .externalId(jwt.subject)
                .email(email)
                .name(jwt.getClaimAsString("name") ?: jwt.getClaimAsString("preferred_username") ?: email)
                .build()
        )
    }!!
}
