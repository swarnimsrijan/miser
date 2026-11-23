package com.miser.moneyTracker.user;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class User {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    /** OIDC subject ("sub") from the identity provider. */
    @Column(name = "external_id", unique = true)
    private String externalId;

    /** Legacy local-login hash; unused since login moved to Keycloak. */
    @Column(name = "password_hash")
    private String passwordHash;

    @Column(nullable = false)
    private String name;

    @Column(name = "profile_image")
    private String profileImage;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() { createdAt = LocalDateTime.now(); }
}
