#!/bin/sh
# Points the Keycloak "miser-app" client at the production web domain (the
# imported realm only knows localhost). Run on the server after first start.
set -eu
. ./.env.prod
docker compose --env-file .env.prod -f compose.prod.yaml exec -T \
  -e KC_PW="$KEYCLOAK_ADMIN_PASSWORD" -e APP="https://$APP_DOMAIN" keycloak sh -c '
B=/opt/keycloak/bin/kcadm.sh
$B config credentials --server http://localhost:8080 --realm master --user admin --password "$KC_PW" >/dev/null
ID=$($B get clients -r miser -q clientId=miser-app --fields id --format csv --noquotes)
$B update clients/$ID -r miser \
  -s "redirectUris=[\"$APP/*\",\"com.miser.app:/oauthredirect\"]" \
  -s "webOrigins=[\"$APP\"]" \
  -s "attributes.\"post.logout.redirect.uris\"=$APP/*##com.miser.app:/logout"
$B update realms/miser -s sslRequired=all'
echo "miser-app client now allows $APP"
