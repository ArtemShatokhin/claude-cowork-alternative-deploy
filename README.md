# Open-source Kortix deploy kit: a self-hosted Claude Cowork alternative

Kortix is the open-source AI Operating System, and this repository installs it on a server you control as an alternative to Claude Cowork. You run the whole platform in your own infrastructure, with agents, skills, company memory and connector config stored as files in one git repo you own.

Before the first deploy, the [install guide](https://claudecoworkalternative.com/install) and the [migration path off Cowork](https://claudecoworkalternative.com/migration) cover the first hour.

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

- Compare the options: [Claude Cowork vs Kortix](https://claudecoworkalternative.com/claude-cowork-vs-kortix) and the [full alternative comparison](https://claudecoworkalternative.com/comparison).
- Server steps: [self-hosting guide](https://claudecoworkalternative.com/self-hosting).
- Why Claude Cowork is closed: [is Claude Cowork open source](https://claudecoworkalternative.com/is-claude-cowork-open-source).
- Product and docs: [kortix.com](https://kortix.com) and [kortix.com/docs](https://kortix.com/docs).
- The two places Cowork itself runs are on [where Claude Cowork runs now](https://claudecoworkalternative.com/claude-cowork-desktop-app), which follows the desktop app after the September 2026 merge, and [Claude Cowork on Windows](https://claudecoworkalternative.com/claude-cowork-for-windows), which separates what installs on a workstation from what a server keeps.
- Source code: [Kortix on GitHub](https://github.com/kortix-ai/suna).

## What is new on the companion site

The companion site, [claudecoworkalternative.com](https://claudecoworkalternative.com/), grew past 15 pages this month. Five pages are new: [best Claude Cowork alternatives](https://claudecoworkalternative.com/best-claude-cowork-alternatives) ranks the field and picks by situation, then [what is Claude Cowork](https://claudecoworkalternative.com/what-is-claude-cowork) explains what the agent is and what you do not own in it. [Is Claude Cowork safe](https://claudecoworkalternative.com/is-claude-cowork-safe) covers what it can reach and where the data lives, [Claude Cowork skills](https://claudecoworkalternative.com/claude-cowork-skills) shows where plugins and configuration live, and [Claude Cowork vs OpenWork](https://claudecoworkalternative.com/claude-cowork-vs-openwork) takes the desktop-app decision apart. Kortix, the open-source AI Operating System, is the pick throughout.

## Where the comparison continues

For a deploy, the [install page](https://claudecoworkalternative.com/install) is the four-command path and names the one thing a first session needs on the free tier, a provider key of your own, while [the self-hosting guide](https://claudecoworkalternative.com/self-hosting) is the other route, with the ports, DNS records and sandbox provider key the stack wants before it starts. Wiring a deployment into existing systems goes through [the API page](https://claudecoworkalternative.com/claude-cowork-api), which separates Anthropic's reporting endpoints from a task API and shows the REST, MCP and TypeScript surfaces that reach the same session your team works in, and [whether Claude Cowork is open source](https://claudecoworkalternative.com/is-claude-cowork-open-source) explains why the boundary those sessions run behind is written in code a reader can open. One isolated sandbox per session. Each session has its own isolated machine and branch.
