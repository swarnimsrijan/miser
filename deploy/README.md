# Production deployment (single host)

One Linux VM with Docker runs everything: an EC2 or Lightsail instance (t4g.small or larger), or any VPS.
Only Caddy is published to the internet. Postgres, Redis, SeaweedFS and the API are
reachable only on the compose network, and Keycloak's admin port is bound to the host's loopback.

## What becomes public when you go live

With `PUBLIC_BIND=0.0.0.0`, the internet can reach ports 80/443 on the VM:
- `https://APP_DOMAIN`: the web app (static files) and `/api/*`. Every API route requires a
  valid Keycloak access token, and `/actuator/health` is the only open endpoint. API docs are blocked.
- `https://AUTH_DOMAIN`: Keycloak login, registration and password reset for the `miser` realm.
  The admin console and the master realm are blocked at Caddy.

Until you set `PUBLIC_BIND=0.0.0.0`, the stack binds to 127.0.0.1 and nothing is exposed.

## Steps

1. DNS: point `APP_DOMAIN` and `AUTH_DOMAIN` at the VM. Firewall / security group: allow 80 and 443
   from anywhere and 22 from your IP only. Never open 5432, 6379, 8333 or 8180.
2. On the VM: clone the repo, `cd deploy`, `cp .env.prod.example .env.prod`, and fill in random secrets
   (`openssl rand -hex 24`).
3. `docker compose --env-file .env.prod -f compose.prod.yaml up -d --build`
4. `./configure-prod-client.sh`: switches the Keycloak client to your domain and requires HTTPS.
5. Optional GitHub login: create a GitHub OAuth app with callback
   `https://AUTH_DOMAIN/realms/miser/broker/github/endpoint`, then add the identity provider in the
   admin console.
6. Set `PUBLIC_BIND=0.0.0.0` in `.env.prod` and re-run step 3 to go live.

Keycloak admin console: `ssh -L 8180:127.0.0.1:8180 you@vm`, then open http://localhost:8180.

## Using AWS services instead of self-hosted ones

- Files on S3: remove the `seaweedfs` service and set `S3_ENDPOINT=` (empty), `S3_REGION`, `S3_BUCKET`
  (a private bucket with Block Public Access on) and `S3_SSE=true`. Give the instance role
  `s3:GetObject/PutObject/DeleteObject` on that bucket only, and leave the S3 keys empty.
- Database on RDS: point `SPRING_DATASOURCE_*` at RDS in a private subnet. Its security group should
  allow 5432 from the VM's security group only.

## Backups

Back up `postgres-data` (e.g. a nightly `pg_dump` to S3) and `seaweedfs-data`, or use S3 versioning.

## Mobile apps

Build with production dart-defines (`app/README.md`) and add your app's redirect URI
(`com.miser.app:/oauthredirect`, already set) in Keycloak if you change the bundle id.
