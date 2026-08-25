# Plane CLI operation guide

This skill targets `mggarofalo/plane-cli`, a compiled Go client whose executable
is named `plane`.

## Connection check

Use the version command, then inspect authentication status and the current user
before work. Use the documented interactive login flow where a user must supply
credentials. Do not place API keys in project files.

## Safe interaction pattern

1. Read the relevant project and work item with JSON output.
2. Resolve project, member, state, and other names before a write.
3. Show the intended update in the delivery plan and obtain the required user
   approval.
4. Dry-run the change when available.
5. Execute one bounded change.
6. Read the record again and compare it with the approved intent.

## Useful resource groups

- `project`: project metadata and discovery.
- `issue`: delivery work items, including creation and updates.
- `member`: workspace or project members for assignment resolution.
- `state`: workflow state discovery and transitions.
- `cycle`, `module`, `epic`, and `initiative`: delivery organization.
- `relation` and `link`: dependencies and related work.
- `comment` and `activity`: traceable delivery updates.

## Agent-oriented output

Use JSON output for reads and explicit workspace/project context for writes.
The CLI can resolve human-readable names; use strict handling when a wrong match
would change a record. Keep raw identifiers inside the adapter workflow rather
than presenting them as a delivery decision.
