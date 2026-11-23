# Builds the Flutter web app and serves it, plus TLS and reverse proxying, with Caddy.
FROM ghcr.io/cirruslabs/flutter:stable AS build
ARG APP_DOMAIN
ARG AUTH_DOMAIN
WORKDIR /src
COPY . .
RUN flutter pub get && flutter build web --release \
      --dart-define=API_BASE_URL=https://${APP_DOMAIN} \
      --dart-define=OIDC_ISSUER=https://${AUTH_DOMAIN}/realms/miser \
      --dart-define=OIDC_CLIENT_ID=miser-app

FROM caddy:2
COPY --from=build /src/build/web /srv
