---
name: plane-cli-adapter
description: Safely read and update Plane through the compiled plane-cli client. Use when a task needs Plane data or an approved Plane change; do not use it to decide delivery scope, priorities, or assignments.
---

# Plane CLI Adapter

Use the `plane` command-line client as a narrow integration layer for Plane.
It executes an approved delivery decision; it does not make the decision.

## Preconditions

Read [the setup guide](references/setup.md), then confirm that the `plane` binary
is installed and the required environment is configured before a workflow
depends on it. Use the authenticated workspace and explicit project context. Do
not expose API tokens in command output, tickets, comments, or repository files.

Run `scripts/preflight.sh` before the first Plane operation in a session. Treat
any failure as a prerequisite blocker and report its remediation; do not attempt
login or a Plane write. The check is read-only and suppresses authentication
details rather than echoing account metadata or secrets.

Read [the operation guide](references/operation-guide.md) when interacting with
Plane.

## Read operations

Prefer JSON output for agent consumption. Read current project, work-item,
state, member, dependency, cycle, and comment data before proposing a change.
When names could be ambiguous, resolve them first and report the ambiguity
rather than guessing.

## Write operations

Only create, edit, assign, or change Plane records after the delivery manager
has the user's approval for that change. Before writing, use the CLI's dry-run
facility where the command supports it and summarize the intended effect.

After a successful write, read the affected record back and confirm the material
fields: title, owner, status, priority, dependency, or dates as applicable.
Never perform delete operations as part of ordinary project management. Treat
bulk changes as a separate, explicitly approved operation.

## Operational boundary

Keep the adapter's result factual: what was read, what was changed, and whether
the verification matched the intended state. Send delivery interpretation,
assignment decisions, escalations, and status reporting back to the project
manager skill.
