# Open-source Kortix deploy kit: a self-hosted Claude Cowork alternative

Kortix is the open-source AI Management System, and this repository installs it on a server you control as an alternative to Claude Cowork. You run the whole platform in your own infrastructure, with agents, skills, company memory and connector config stored as files in one git repo you own.

## What this repository is

This is a deployment kit for open-source Kortix. It provisions the infrastructure around the platform, then installs the app with the official installer. The app stays upgradeable on its own, and the infrastructure is plain Docker Compose.

Four files do the work:

- `deploy/docker-compose.yml` starts Caddy for TLS and Postgres 16 for the app database.
- `deploy/Caddyfile` points Caddy at your domain, obtains a Let's Encrypt certificate automatically, and reverse-proxies the Kortix web app and API on port 8000.
- `deploy/install.sh` installs Docker, creates `deploy/.env` from `deploy/.env.example` if it is missing, brings up the stack, then runs the official installer `curl -fsSL https://kortix.com/install | bash`.
- `deploy/.env.example` holds the values you set before the first run: `KORTIX_DOMAIN`, `ACME_EMAIL`, and the Postgres credentials.

`agents/migration-lead.md` is a Kortix agent definition, and in Kortix an agent is a markdown file in the project repo. It carries the checklist for moving a team off Claude Cowork.

## Who this repository is for

This kit is for a team that already runs work through Claude Cowork and needs to own the system that work runs on. It fits teams that must keep data on their own VPS, VPC or hardware, that want to use their own model keys, or that need every outbound action to pass a human review before it runs.

You need a host with Docker and a domain you can point at it. Nothing else is required to start.

## Quickstart

1. Copy this repository onto the host and point your domain's DNS A or AAAA record at that machine.
2. Create your environment file from the example and edit it:
   ```bash
   cp deploy/.env.example deploy/.env
   # set KORTIX_DOMAIN, ACME_EMAIL and POSTGRES_PASSWORD
   ```
3. Run the bootstrap:
   ```bash
   bash deploy/install.sh
   ```
4. Open `https://$KORTIX_DOMAIN` and create your first project.

`deploy/install.sh` is deliberately small. It runs the documented install command and standard Debian or Ubuntu package setup, so you can read every line before you run it. Full server steps, TLS details and upgrades are in [docs/self-hosting.md](docs/self-hosting.md).

## What you get

- The company as one git repo: agents, skills, memory, connector config and triggers are files you can grep, diff and roll back.
- 3,000+ apps plus any MCP, OpenAPI, GraphQL or HTTP API, with credentials brokered server-side and allow, ask or block on each tool call.
- Any model, your keys: Claude, OpenAI, Gemini or your own OpenAI-compatible endpoint, chosen per agent, per session, per message.
- A real agent harness powered by OpenCode that plans, uses tools and finishes multi-step runs.
- An isolated Linux machine per session, with thousands able to run in parallel.
- Work that lands as a change request a human reads as a diff.

## Learn more

- Compare the options: [Claude Cowork vs Kortix](https://claudecoworkalternative.com/claude-cowork-vs-kortix.html) and the [full alternative comparison](https://claudecoworkalternative.com/comparison.html).
- Server steps: [self-hosting guide](https://claudecoworkalternative.com/self-hosting.html).
- Why Claude Cowork is closed: [is Claude Cowork open source](https://claudecoworkalternative.com/is-claude-cowork-open-source.html).
- Product and docs: [kortix.com](https://kortix.com) and [kortix.com/docs](https://kortix.com/docs).
- Source code: [Kortix on GitHub](https://github.com/kortix-ai/suna).
