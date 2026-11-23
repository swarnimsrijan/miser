# Miser app (Flutter: web, Android, iOS)

One Flutter codebase for the Miser personal-finance client. It talks to the
Spring backend in `../moneyTracker` and signs in through Keycloak (OIDC
authorization code + PKCE, public client `miser-app`).

## Prerequisites

- Flutter 3.50+ (`flutter doctor`)
- Backend on `http://localhost:8080` and Keycloak on `http://localhost:8180`
  (realm `miser`), started from `../moneyTracker` (see its README / compose file)
- To regenerate the API client: Node (for `npx`), Java 11+, python3

## Run

### Web

```sh
flutter run -d web-server --web-port 5000 --web-hostname localhost
# then open http://localhost:5000
```

Use port 5000 on `localhost`. That is the origin registered in Keycloak
(`http://localhost:5000/*`) and allowed by the backend's CORS config. Keep the
`localhost` hostname: don't bind to `0.0.0.0`, which would expose the dev
server to your network.

> macOS: the AirPlay Receiver (Control Center) also listens on port 5000, on all
> interfaces. Flutter's server binds `[::1]:5000`, so browsers that resolve
> `localhost` to `::1` reach the app. If you get a 403 or a blank page, turn off
> System Settings > General > AirDrop & Handoff > AirPlay Receiver.

Build for release: `flutter build web` (output in `build/web`). Any static host
must fall back to `index.html` for unknown paths (path-based URLs are used), and
must serve `redirect.html`.

### Android (emulator or device)

The access token's issuer must be exactly `http://localhost:8180/realms/miser`,
so the device has to reach Keycloak and the API as `localhost`, not `10.0.2.2`.
Forward the ports over adb:

```sh
adb reverse tcp:8080 tcp:8080
adb reverse tcp:8180 tcp:8180
flutter run -d <device-id>
```

Run `adb reverse` again after the emulator or device reconnects. Cleartext
HTTP is allowed only for `localhost` / `127.0.0.1`
(`android/app/src/main/res/xml/network_security_config.xml`).

### iOS (simulator)

The simulator shares the Mac's network, so `localhost` works as-is:

```sh
open -a Simulator
flutter run -d <simulator-id>
```

On a physical iPhone, `localhost` is the phone itself. You would need the
backend and Keycloak reachable under a hostname that matches the token issuer,
which is outside this dev setup. `NSAllowsLocalNetworking` in `Info.plist`
permits plain HTTP to localhost.

## Configuration (`--dart-define`)

| Define           | Default                              | Purpose                   |
|------------------|--------------------------------------|---------------------------|
| `API_BASE_URL`   | `http://localhost:8080`              | Spring backend            |
| `OIDC_ISSUER`    | `http://localhost:8180/realms/miser` | Keycloak realm (issuer)   |
| `OIDC_CLIENT_ID` | `miser-app`                          | Public OIDC client        |

```sh
flutter run -d web-server --web-port 5000 --web-hostname localhost \
  --dart-define=API_BASE_URL=http://localhost:8080 \
  --dart-define=OIDC_ISSUER=http://localhost:8180/realms/miser \
  --dart-define=OIDC_CLIENT_ID=miser-app
```

Redirect URIs (these must match the Keycloak client):

| Platform | Sign-in redirect                      | Post-logout redirect                |
|----------|---------------------------------------|-------------------------------------|
| Web      | `http://localhost:5000/auth/callback` | `http://localhost:5000/auth/logout` |
| Mobile   | `com.miser.app:/oauthredirect`        | `com.miser.app:/logout`             |

## Authentication

- `package:oidc` handles authorization code + PKCE (S256). Scopes:
  `openid profile email offline_access`. The app never sees passwords.
  Sign-up, password reset and social login happen on Keycloak's pages.
- Web uses a full-page redirect. Keycloak sends the browser back to
  `/auth/callback`. A small script in `web/index.html` forwards that to
  `web/redirect.html` (copied from `package:oidc`; re-copy it when you upgrade
  the package). `redirect.html` stores the response and returns to the app,
  which finishes the code exchange on startup.
- Android: `manifestPlaceholders["oidcRedirectScheme"] = "com.miser.app"` in
  `android/app/build.gradle.kts`. The plugin ships the redirect activity and
  its intent filter. iOS: `CFBundleURLTypes` registers the `com.miser.app`
  scheme in `ios/Runner/Info.plist`.
- Tokens are stored by `oidc_default_store`: Keychain / Android Keystore
  (`flutter_secure_storage`) on mobile, browser storage on web. Tokens refresh
  automatically before they expire. On a 401 the dio interceptor
  (`lib/core/api/auth_interceptor.dart`) force-refreshes once and retries. If
  that also fails, it drops the session and the router sends the user to
  sign-in.
- Tokens and statement passwords are never logged. No dio `LogInterceptor` is
  installed. Statement passwords are sent only as a multipart form field.

## API client

`packages/miser_api` is generated from `../api/openapi.json` with
openapi-generator (`dart-dio`, json_serializable). Don't edit it by hand.
Regenerate it with:

```sh
tool/generate_api.sh            # or: tool/generate_api.sh path/to/openapi.json
```

To refresh the spec from a running backend first:
`curl -s http://127.0.0.1:8080/v3/api-docs > ../api/openapi.json`.

The script patches a temporary copy of the spec before generating. The real
`POST /api/statements/upload` takes multipart form data (`file`, `accountId` /
`creditCardId`, `password`), but springdoc describes it as a JSON body with
query parameters. The script also aligns `copy_with_extension` with
`package:oidc`.

The dashboard endpoints (`/api/dashboard/*`) return untyped maps, and the
generated client can't deserialize those. They are called through a small
hand-written client (`lib/features/home/dashboard_api.dart`) on the same dio
instance, with models in `dashboard_models.dart`.

## Project layout

```
lib/
  core/
    config/      dart-define configuration
    auth/        AuthService abstraction + OIDC implementation
    api/         dio + auth interceptor, generated-client provider, errors
    router/      go_router with the auth redirect guard (auth_redirect.dart)
    theme/       Material 3 light/dark themes, theme-mode preference
    formatting/  INR (Indian digit grouping) and date helpers
    widgets/     shared UI pieces
  features/
    auth/ shell/ home/ accounts/ statements/ transactions/
    budgets/ goals/ planner/ recurring/ profile/
packages/miser_api/   generated OpenAPI client
tool/generate_api.sh  client generator
```

Layout is responsive. Windows 840 px and wider get a navigation rail (extended
from 1240 px). Narrower windows get a bottom bar, with Accounts, Goals,
Planner, Recurring and Profile under "More".

## Checks

```sh
flutter analyze
flutter test
flutter build web
```
