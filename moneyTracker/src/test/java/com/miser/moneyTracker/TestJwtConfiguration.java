package com.miser.moneyTracker;

import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jose.jwk.source.ImmutableJWKSet;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.oauth2.jwt.NimbusJwtDecoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.time.Instant;

/**
 * Stands in for Keycloak in tests: a throwaway RSA key signs tokens shaped
 * like Keycloak access tokens, and the app's JwtDecoder trusts only that key.
 */
@TestConfiguration(proxyBeanMethods = false)
public class TestJwtConfiguration {

    private static final KeyPair KEYS = generate();

    @Bean
    JwtDecoder jwtDecoder() {
        return NimbusJwtDecoder.withPublicKey((RSAPublicKey) KEYS.getPublic()).build();
    }

    public static String token(String subject, String email, String name) {
        RSAKey jwk = new RSAKey.Builder((RSAPublicKey) KEYS.getPublic())
                .privateKey((RSAPrivateKey) KEYS.getPrivate()).build();
        NimbusJwtEncoder encoder = new NimbusJwtEncoder(new ImmutableJWKSet<>(new JWKSet(jwk)));
        Instant now = Instant.now();
        JwtClaimsSet.Builder builder = JwtClaimsSet.builder();
        if (subject != null) builder.subject(subject);
        JwtClaimsSet claims = builder
                .issuer("http://test-issuer/realms/miser")
                .audience(java.util.List.of("miser-api"))
                .issuedAt(now)
                .expiresAt(now.plusSeconds(600))
                .claim("email", email)
                .claim("email_verified", true)
                .claim("name", name)
                .build();
        return encoder.encode(JwtEncoderParameters.from(claims)).getTokenValue();
    }

    private static KeyPair generate() {
        try {
            KeyPairGenerator generator = KeyPairGenerator.getInstance("RSA");
            generator.initialize(2048);
            return generator.generateKeyPair();
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
