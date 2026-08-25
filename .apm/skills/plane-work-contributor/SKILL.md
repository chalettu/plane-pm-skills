---
name: plane-work-contributor
description: Let an execution agent safely manage its own assigned Plane work. Use to read assigned issues, report progress and blockers, and update status with evidence; do not use for team-wide planning or project control.
---

# Plane Work Contributor

Manage only the Plane work that is assigned to the current execution agent. Use
the `plane-cli-adapter` skill for every Plane interaction.

## Confirm ownership and context

Before acting, read the assigned work item and confirm that the execution agent
is the active assignee. Read its description, acceptance criteria, dependencies,
current status, and relevant comments. If the mapping between the agent and the
Plane assignee is not explicit, operate read-only and ask the delivery manager
to resolve it.

Do not begin work that is blocked by an unmet dependency or lacks the inputs
needed to execute it. Report the blocker instead of inventing missing decisions.

## Permitted updates

- Move an owned item to the team's active status when work actually begins.
- Post compact progress updates that state completed work, the next step, and a
  newly material risk or blocker.
- Move an owned item to the review or completed status only when its acceptance
  criteria are met and the relevant evidence is recorded in Plane.
- Add links, test results, implementation notes, or other completion evidence
  that a reviewer can use to verify the work.

Read the item back after each update. Use the configured workflow states; do not
invent new states or status meanings.

## Escalate to the delivery manager

Do not change scope, priority, target date, owner, dependencies, estimate, or
acceptance criteria. Do not create or divide work items, assign another agent,
or alter a project plan.

Escalate when a requirement is ambiguous, a dependency is blocked, the estimate
or forecast materially changes, a defect affects other work, or completing the
item would require a scope decision. Include the observed fact, delivery impact,
and the smallest decision or action needed.

## Communication standard

Keep updates factual and tied to the assigned item. Do not claim completion
without evidence. Avoid routine commentary when there is no meaningful change;
the delivery manager reports the wider project status.
