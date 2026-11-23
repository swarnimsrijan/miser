# miser

Personal finance planner: upload bank and credit-card statements (PDF/CSV/XLSX,
including password-protected PDFs), get everything categorized, then plan with
budgets, savings goals, recurring-payment detection and what-if forecasts.
One Flutter app runs on web, Android and iOS. Everything is open source and self-hostable;
AWS is optional (one VM, optionally S3 for files).

## Layout

| Path | What |
|---|---|
| `moneyTracker/` | Backend: Spring Boot 4, Java + Kotlin (new code in Kotlin), PostgreSQL, Flyway |
| `app/` | Flutter client (web, Android, iOS), see `app/README.md` |
| `api/openapi.json` | API contract; the Dart client is generated from it |
| `moneyTracker/compose.yaml` | Local stack: Postgres, Redis, Keycloak, SeaweedFS (all on 127.0.0.1) |
| `deploy/` | Single-host production stack with Caddy (HTTPS), see `deploy/README.md` |

## Stack

- **Auth**: Keycloak (OIDC, authorization code + PKCE). Email sign-up/login and password reset;
  GitHub login via `moneyTracker/infra/keycloak/enable-github-login.sh`. The API is an OAuth2
  resource server that validates the issuer, signature and `miser-api` audience.
- **Files**: any S3-compatible store: SeaweedFS (self-hosted) or Amazon S3. Local disk also works.
- **Parsing**: PDFBox/POI/commons-csv with issuer detection (HDFC, ICICI, SBI, Axis, Kotak, Amex, ...)
  and generic bank and credit-card layouts. Add issuer-specific layouts as `PdfLayout` beans.

## Run locally

Prerequisites: JDK 21+, Docker (with `docker-compose`), Flutter.

```sh
cd moneyTracker
cp .env.example .env      # then replace every change-me with a random value
./gradlew bootRun         # starts the compose stack, then the API on http://127.0.0.1:8080
```

In another terminal:

```sh
cd app
flutter run -d web-server --web-port 5000 --web-hostname localhost
```

Open http://localhost:5000, click **Sign in**, and register on the Keycloak page.
Admin console: http://localhost:8180 (user `admin`, password `KEYCLOAK_ADMIN_PASSWORD` from `.env`).
API docs: http://127.0.0.1:8080/swagger-ui.html

Tests: `cd moneyTracker && ./gradlew test` (uses Testcontainers; no `.env` needed).

## API overview

`/api/me`, `/api/banks`, `/api/accounts`, `/api/credit-cards`, `/api/statements` (upload with an optional
`password` form field, list, delete), `/api/transactions` (search, recategorize, mark transfer),
`/api/dashboard/*`, `/api/reports/{pdf,excel,csv}`, `/api/budgets` (+ `/status`), `/api/goals`
(+ contributions), `/api/planner/{forecast,what-if}`, `/api/insights/{recurring,tips}`,
`/api/reconciliation/run`.

Card bill payments and transfers between your own accounts are linked automatically after each
upload and excluded from income and spend, so nothing is double counted.
