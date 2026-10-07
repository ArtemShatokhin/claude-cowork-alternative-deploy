# Open-source Kortix FAQ: self-hosting and moving off Claude Cowork

Kortix is the open-source AI Management System, and this repository installs it on your own server. These answers cover the questions a team asks before it moves work off Claude Cowork and runs open-source Kortix on its own infrastructure.

## Does Kortix run on my own servers?

Yes. Kortix is the open-source AI Management System and runs on hardware you control: your laptop, a VPS, your VPC or on-prem, or managed cloud if you prefer. Self-hosting is free, and you supply the compute. Kortix is open source (Elastic License 2.0) — self-host, read and modify the code. See the [self-hosting guide](https://claudecoworkalternative.com/self-hosting.html) for the server steps.

## Can I keep my own model keys?

Yes. Kortix runs any model with your own keys: Claude, OpenAI, Gemini or your own OpenAI-compatible endpoint. You choose the model per agent, per session and per message, and you pay the provider directly. Connector credentials are brokered server-side, so raw provider keys do not enter the session machine.

## How do approval gates work?

Kortix gates work by default. Every session runs on its own branch, and finished work arrives as a change request a human reads as a diff before it merges to the default branch. For each tool call you can set allow, ask or block, so an action that sends, posts or pays waits for a human before it runs.

## Is it a desktop app or a server platform?

Kortix is a server-side platform that can also run on a laptop. It deploys as a self-hosted web app and API behind Caddy, with Postgres for the database, and each session gets its own isolated Linux machine. A closed desktop assistant runs only in the vendor's cloud; Kortix runs where your infrastructure and data rules require.

## How does this repository relate to the campaign site?

This repository is the deployment kit. It provisions Caddy and Postgres and installs open-source Kortix with the official installer. The campaign site, [claudecoworkalternative.com](https://claudecoworkalternative.com/), explains the decision to move off Claude Cowork, compares the field, and links the same setup steps. Use the repo to run the platform and the [site FAQ](https://claudecoworkalternative.com/faq.html) to compare options.
