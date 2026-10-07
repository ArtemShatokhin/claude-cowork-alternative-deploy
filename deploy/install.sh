#!/usr/bin/env bash
# Open-source Claude Cowork alternative - bootstrap a self-hosted Kortix host.
#
# This script wraps the official installer and sets up TLS for a single VPS.
# It is deliberately small: everything it does is either the documented
# install command or standard Debian/Ubuntu package setup.
#
#   1. install Docker + the compose plugin
#   2. write deploy/.env from .env.example if missing
#   3. bring up Caddy (TLS) and Postgres
#   4. install the open-source Kortix app via the official installer
#
# Docs: https://claudecoworkalternative.com/self-hosting.html
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

command -v docker >/dev/null 2>&1 || {
  echo "[*] installing docker"
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" || true
}

if [ ! -f "$ROOT/deploy/.env" ]; then
  echo "[*] creating deploy/.env from .env.example - edit KORTIX_DOMAIN first"
  cp "$ROOT/deploy/.env.example" "$ROOT/deploy/.env"
fi

echo "[*] starting infrastructure (Caddy TLS + Postgres)"
docker compose -f "$ROOT/deploy/docker-compose.yml" --env-file "$ROOT/deploy/.env" up -d

echo "[*] installing open-source Kortix (official installer)"
curl -fsSL https://kortix.com/install | bash

echo "[*] done. Open https://\$KORTIX_DOMAIN and create your first project."
echo "    The project lives in one git repo you own - see agents/migration-lead.md"
