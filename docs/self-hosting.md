# Self-hosting open-source Kortix on your own server

Self-hosting Kortix means running the open-source AI Management System on infrastructure you control, so your files, your model keys and your audit trail stay in your accounts. The deploy kit in this repository puts open-source Kortix on a single VPS, a VPC or an on-prem host.

## What self-hosting means here

Kortix runs where your data lives. Every session gets its own isolated Linux machine, and agent work lands on a branch as a change request you review before it merges. Connector credentials are brokered server-side, so raw keys do not enter the session machine.

Self-hosting covers the platform, not just a desktop app. Agents, skills, company memory, connector config and triggers are files in one git repo you own, so you can read, diff and roll back any change. You can also run Kortix on a laptop or use managed cloud; this repository targets a server with a public domain.

## Prerequisites

- A host running a current Debian or Ubuntu, with root or sudo access. One small VPS is enough to start.
- A domain you can control, with an A (or AAAA) record pointing at the host's public IP.
- Docker with the Compose plugin. `deploy/install.sh` installs it for you if it is missing.
- Ports 80 and 443 open to the internet, so Caddy can complete the ACME challenge and serve HTTPS.

## Deploy steps

1. Copy this repository to the host and point the DNS record at the machine. TLS issuance fails until the domain resolves to the host.
2. Create the environment file:
   ```bash
   cp deploy/.env.example deploy/.env
   ```
   Set `KORTIX_DOMAIN` to your hostname, `ACME_EMAIL` to the address Let's Encrypt should use for expiry notices, and a strong `POSTGRES_PASSWORD`. `deploy/.env.example` lists all four values.
3. Start the stack and install the app:
   ```bash
   bash deploy/install.sh
   ```
   The script installs Docker if needed, brings up `deploy/docker-compose.yml` with `--env-file deploy/.env`, and then runs `curl -fsSL https://kortix.com/install | bash`.

`deploy/docker-compose.yml` starts two services. Caddy listens on 80 and 443 and mounts `deploy/Caddyfile` read-only. Postgres 16 listens on `127.0.0.1:5432` only, and its data lives in the `pg-data` volume. The Kortix app itself is installed by the official installer, so it upgrades separately from this infrastructure stack.

## How TLS is handled

Caddy terminates TLS. The site block in `deploy/Caddyfile` uses `{$KORTIX_DOMAIN}` as the hostname and requests a Let's Encrypt certificate automatically, then renews it without intervention. Caddy reverse-proxies the Kortix web app and API on `127.0.0.1:8000` and sets `X-Forwarded-Proto` so the app knows the original request was HTTPS.

The Caddyfile also sets `Strict-Transport-Security`, `X-Content-Type-Options` and `Referrer-Policy` headers. Certificate data and Caddy config persist in the `caddy-data` and `caddy-config` volumes. Open ports 80 and 443 before the first start, and verify the DNS record, or the certificate request will fail.

## Upgrading

Upgrade the Kortix app and the infrastructure separately.

- App: re-run the official installer to move to the current Kortix release. Your project repo and Postgres data are untouched.
- Infrastructure: pull the current images and recreate the containers.
  ```bash
  docker compose -f deploy/docker-compose.yml --env-file deploy/.env pull
  docker compose -f deploy/docker-compose.yml --env-file deploy/.env up -d
  ```

Back up the `pg-data` volume before an upgrade. Postgres stores the app database there.

## Troubleshooting

- No certificate issued: the domain does not resolve to this host, or port 80 is blocked. Check the A/AAAA record and the firewall, then check `docker compose -f deploy/docker-compose.yml logs caddy`.
- Compose refuses to start Postgres: `POSTGRES_PASSWORD` is unset. The compose file requires it, so set it in `deploy/.env`.
- HTTPS serves the wrong host or a self-signed cert: `KORTIX_DOMAIN` does not match the hostname in the browser. Set it in `deploy/.env` and recreate the Caddy container.
- Port 80 or 443 already in use: another web server is bound to the port. Stop it, or move it behind Caddy.
- App install fails: run `curl -fsSL https://kortix.com/install | bash` on its own to see the full installer output.

The campaign site covers the wider decision at [self-hosting an open-source Claude Cowork alternative](https://claudecoworkalternative.com/self-hosting.html). Product documentation is at [kortix.com/docs](https://kortix.com/docs), and the source is at [Kortix on GitHub](https://github.com/kortix-ai/suna).
