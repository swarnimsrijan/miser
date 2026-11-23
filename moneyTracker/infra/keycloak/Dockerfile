# Keycloak with the miser realm baked in (imported on first start; existing
# realms are left untouched). Avoids host bind mounts.
FROM quay.io/keycloak/keycloak:26.4
COPY --chown=keycloak:keycloak realm/ /opt/keycloak/data/import/
