package com.miser.moneyTracker.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.HttpStatus
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.HttpStatusEntryPoint
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource

/**
 * Stateless API secured by Keycloak-issued access tokens (OAuth2 resource
 * server). Issuer and audience are validated from configuration; only health
 * and the API description are reachable without a token.
 */
@Configuration
@EnableWebSecurity
class SecurityConfig(
    @Value("\${app.cors.allowed-origins}") private val allowedOrigins: List<String>,
) {

    @Bean
    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {
        http
            .csrf { it.disable() } // bearer tokens only, no cookies
            .cors { }
            .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
            .authorizeHttpRequests {
                it.requestMatchers("/actuator/health", "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html")
                    .permitAll()
                    .anyRequest().authenticated()
            }
            .oauth2ResourceServer { it.jwt { } }
            .exceptionHandling { it.authenticationEntryPoint(HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)) }
        return http.build()
    }

    @Bean
    fun corsConfigurationSource(): CorsConfigurationSource {
        val config = CorsConfiguration().apply {
            allowedOrigins = this@SecurityConfig.allowedOrigins.filter { it.isNotBlank() }
            allowedMethods = listOf("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
            allowedHeaders = listOf("Authorization", "Content-Type")
            exposedHeaders = listOf("Content-Disposition")
            maxAge = 3600
        }
        return UrlBasedCorsConfigurationSource().apply { registerCorsConfiguration("/api/**", config) }
    }
}
