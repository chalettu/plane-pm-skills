# AI Project Manager for Plane

This is a three-skill foundation for an AI project manager that coordinates other
AI agents while using Plane as the delivery system of record.

## Why three skills

Project management and software integration have different responsibilities.
Separating them keeps the project manager focused on coordination and prevents a
command-line integration from deciding what work should be done.

| Skill | Responsibility | Does not do |
|---|---|---|
| [Plane Delivery Manager](.apm/skills/plane-delivery-manager/SKILL.md) | Turns an analyst's work brief into an approval-ready delivery plan; matches work to the agent roster; coordinates approved execution; manages risks, blockers, and change control. | Business analysis, requirements definition, or technical solution design. |
| [Plane CLI Adapter](.apm/skills/plane-cli-adapter/SKILL.md) | Reads and updates Plane through the selected compiled `plane` command-line client. | Delivery planning, prioritization, or choosing which agent should do the work. |
| [Plane Work Contributor](.apm/skills/plane-work-contributor/SKILL.md) | Lets an execution agent read and update only its assigned work, including evidence-based status changes and blockers. | Reassigning work, changing scope or priority, or team-wide project control. |

## Operating model

1. An analysis agent supplies a structured work brief: objective, work items,
   dependencies, priority, acceptance criteria, assumptions, and open decisions.
2. The delivery manager checks whether the brief is manageable. If not, it asks
   the analysis agent for clarification rather than inventing scope.
3. The delivery manager reads the team roster, proposes assignments and a
   sequenced delivery plan, then presents it to the user for approval.
4. Only after approval does the delivery manager direct execution. Contributor
   agents update their own work through the CLI adapter; the manager maintains
   the delivery-level record.
5. The delivery manager may make small scheduling or reassignment changes inside
   the approved plan. Scope, priority, budget, deadline, and success-criteria
   changes return to the user for approval.
6. At closeout, the delivery manager proposes evidence-based roster updates.
   The user must approve them before team memory changes.

## Agent roster

The delivery manager maintains its team memory in
[agent-roster.md](.apm/skills/plane-delivery-manager/references/agent-roster.md). Populate
it with each agent's demonstrated strengths, constraints, availability, and the
evidence behind those observations. This lets the manager explain why an agent
is a good assignment match instead of assigning by generic role alone.

## Plane integration

The adapter targets the selected compiled Go-based `plane-cli` client. It expects
the `plane` binary to be installed and authenticated before it operates.

The adapter follows a safe pattern:

1. Read the current Plane state using structured output.
2. Resolve ambiguous project, state, and member names.
3. Confirm the intended update is covered by the approved delivery plan.
4. Dry-run the change when supported.
5. Make one bounded update.
6. Read the record back to confirm the intended result.

The adapter does not delete Plane data as part of normal project management.

## APM package

This repository uses the standard Microsoft Agent Package Manager source layout:
the package manifest is [apm.yml](apm.yml), and the three skill bundles live
under `.apm/skills/`. Install the repository with `apm install <repository>` or
select one bundled skill with `apm install <repository> --skill <skill-name>`.

The manifest declares the current package version as `0.1.0`, explicitly lists
the three publishable skill bundles, and records the package as `UNLICENSED`
until the owner selects a distribution license. Packing or publishing should be
preceded by `apm compile --validate` and `apm pack --dry-run --verbose`.

