# Plane CLI environment setup

This adapter targets [`mggarofalo/plane-cli`](https://github.com/mggarofalo/plane-cli),
whose executable is `plane`. Configure it before an agent attempts any Plane
operation. The examples below contain placeholders only.

## Required settings for agents and automation

Supply all three values in the process environment:

| Variable | Value |
|---|---|
| `PLANE_API_KEY` | A Plane personal API token. Treat this value as a secret. |
| `PLANE_URL` | The Plane instance base URL, such as `https://plane.example.com`. This CLI uses `PLANE_URL`, not `PLANE_BASE_URL`. |
| `PLANE_WORKSPACE` | The workspace slug from the Plane workspace URL. |

For a temporary shell session, use placeholder values and enter the key without
printing it:

```sh
export PLANE_URL="https://plane.example.com"
export PLANE_WORKSPACE="workspace-slug"
read -r -s PLANE_API_KEY
export PLANE_API_KEY
```

The `read -s` form keeps the token off the screen and out of shell history. The
variables last only for that shell and its child processes. Clear them when the
session ends or run `unset PLANE_API_KEY PLANE_URL PLANE_WORKSPACE`.

## Secure ways to supply the API key

- Prefer a secret manager that injects `PLANE_API_KEY` into only the process
  that runs the agent or CLI.
- In CI, use the platform's encrypted and masked secret store. Map the secret to
  `PLANE_API_KEY` at job runtime and restrict it to trusted branches and jobs.
- For a human-operated workstation, `plane auth login` stores credentials in the
  operating-system keyring. Do not automate that interactive flow; the CLI's own
  guidance recommends environment variables for agents and scripts.
- If local tooling requires a file such as `.env.plane`, keep it outside version
  control, restrict its filesystem permissions, and load it only into the
  intended process. This repository's `.gitignore` excludes `.env.*`, but an
  ignore rule is not a security boundary.

Never put a real token in a command argument, committed file, ticket, comment,
log, screenshot, prompt, or chat message. Never print `PLANE_API_KEY` to verify
it. Rotate the token immediately if it is exposed.

## Optional profiles and defaults

`PLANE_PROFILE` optionally selects or overrides the active saved profile, which
is useful when one workstation accesses multiple Plane instances. It does not
replace the required connection values unless the selected profile already
provides them. Humans can create or switch profiles with the CLI's `auth`
commands.

The CLI can keep non-secret defaults such as the instance URL, workspace, and
docs URL in its user configuration at
`$XDG_CONFIG_HOME/plane-cli/config.json` or, when `XDG_CONFIG_HOME` is unset,
`~/.config/plane-cli/config.json`. The API key belongs in the OS keyring or the
process environment, not in that JSON file. `PLANE_DOCS_URL` optionally selects
a custom API-documentation base URL, and `PLANE_NO_UPDATE_CHECK=1` disables the
startup update check.

The CLI resolves settings in this order: command-line flag, environment
variable, config file, then built-in default. Prefer an explicit
`PLANE_WORKSPACE` for agent work even when a profile has a default, and use the
global `--workspace` flag for a deliberately scoped one-command override.

## Safe verification

After configuration, verify without displaying secrets:

```sh
plane --version
plane auth status
plane me
```

Do not run these checks in logs that could expose account or workspace metadata.
The adapter should remain read-only until identity, instance, and workspace are
confirmed.
