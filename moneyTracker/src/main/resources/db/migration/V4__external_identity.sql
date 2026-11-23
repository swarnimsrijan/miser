-- Users now authenticate through Keycloak (OIDC). The token subject links
-- the identity to the local user row; local passwords are no longer used.
ALTER TABLE users ADD COLUMN external_id VARCHAR(255) UNIQUE;
ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;
