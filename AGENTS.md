# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates IAM groups, managed policies, roles (with optional instance profiles), and users (with optional access keys). Each is set with a list input (`groups`, `policies`, `roles`, `users`), and `policy_documents` renders policy JSON from templates that the other inputs can refer to by name. It outputs the created resources as `groups`, `policies`, `policy_documents`, `roles`, and `users`; `users` is marked sensitive.

### Module-specific files

- `modules/group/` — Creates an IAM group with its managed policy attachments, inline policies, and user memberships; the root module calls it once per entry in `groups`
- `modules/policy/` — Creates one IAM managed policy; the root module calls it once per entry in `policies`
- `modules/policy_document/` — Renders and merges policy templates found in `template_paths` into one policy document; the root module calls it once per entry in `policy_documents`
- `modules/role/` — Creates an IAM role with its inline and managed policies and an optional instance profile; the root module calls it once per entry in `roles`
- `modules/user/` — Creates an IAM user with its inline and managed policies and optional access keys; the root module calls it once per entry in `users`
- `tests/templates/` — Policy and trust templates shared by the test scenarios
- `tests/resource_cycle/` — A policy template only, with no scenario of its own; several scenarios list it in their template paths
