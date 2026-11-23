#!/bin/sh
# Adds "Sign in with GitHub" to the miser realm.
# 1. Create a GitHub OAuth app (GitHub > Settings > Developer settings > OAuth Apps)
#    with callback URL: http://localhost:8180/realms/miser/broker/github/endpoint
# 2. Put GITHUB_CLIENT_ID and GITHUB_CLIENT_SECRET in .env, then run this script
#    from the moneyTracker directory while Keycloak is running.
set -eu
. ./.env
: "${GITHUB_CLIENT_ID:?set GITHUB_CLIENT_ID in .env}"
: "${GITHUB_CLIENT_SECRET:?set GITHUB_CLIENT_SECRET in .env}"
CONTAINER=$(docker ps --filter "ancestor=miser-keycloak:dev" --format '{{.Names}}' | head -1)
KCADM="docker exec -i $CONTAINER /opt/keycloak/bin/kcadm.sh"
# Credentials go over stdin/env of the exec, not the host command line.
docker exec -i -e KC_PW="$KEYCLOAK_ADMIN_PASSWORD" "$CONTAINER" sh -c \
  '/opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080 --realm master --user admin --password "$KC_PW"' >/dev/null
docker exec -i -e ID="$GITHUB_CLIENT_ID" -e SECRET="$GITHUB_CLIENT_SECRET" "$CONTAINER" sh -c \
  '/opt/keycloak/bin/kcadm.sh create identity-provider/instances -r miser \
     -s alias=github -s providerId=github -s enabled=true -s trustEmail=true \
     -s "config.clientId=$ID" -s "config.clientSecret=$SECRET" -s config.syncMode=IMPORT' \
  || $KCADM update identity-provider/instances/github -r miser -s enabled=true
echo "GitHub login enabled for realm miser"
