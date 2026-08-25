#!/bin/sh

# Read-only prerequisite check for mggarofalo/plane-cli.
# This script never logs in, changes configuration, or calls a Plane data API.

set -u

fail() {
  printf 'Plane CLI preflight: FAIL - %s\n' "$1" >&2
  printf 'Remediation: %s\n' "$2" >&2
  exit 1
}

if ! command -v plane >/dev/null 2>&1; then
  fail \
    'the plane executable is not available on PATH.' \
    'Install mggarofalo/plane-cli using its official instructions, then rerun this check.'
fi

if ! PLANE_NO_UPDATE_CHECK=1 plane --version >/dev/null 2>&1; then
  fail \
    'the plane executable was found, but its version could not be read.' \
    'Check that the binary is executable and run "plane --version" manually.'
fi

# Capture and inspect status without printing it; status may contain account or
# workspace metadata. The command is documented as a read-only auth inspection.
auth_status=''
auth_status_ok=0
if auth_status=$(PLANE_NO_UPDATE_CHECK=1 plane auth status 2>&1); then
  auth_status_ok=1
fi

if [ -n "${PLANE_API_KEY:-}" ]; then
  auth_ready=1
elif [ "$auth_status_ok" -eq 1 ] &&
  ! printf '%s\n' "$auth_status" | grep -Eiq \
    'not authenticated|not logged in|no (credential|authentication|api key)|missing (credential|authentication|api key)'; then
  auth_ready=1
else
  auth_ready=0
fi

if [ "$auth_ready" -ne 1 ]; then
  fail \
    'no usable API-key environment setting or authenticated profile was found.' \
    'Set PLANE_API_KEY securely for automation, or have a human configure the OS-keyring profile; this check never runs login.'
fi

if [ -n "${PLANE_URL:-}" ]; then
  url_ready=1
elif [ "$auth_status_ok" -eq 1 ] &&
  printf '%s\n' "$auth_status" | grep -Eiq \
    '(api[[:space:]_-]*url|instance|url)[[:space:]_:-]+https?://'; then
  url_ready=1
else
  url_ready=0
fi

if [ "$url_ready" -ne 1 ]; then
  fail \
    'no Plane instance URL could be resolved from PLANE_URL or the active profile.' \
    'Set PLANE_URL to the Plane instance base URL, or select a profile that defines it.'
fi

if [ -n "${PLANE_WORKSPACE:-}" ]; then
  workspace_ready=1
elif [ "$auth_status_ok" -eq 1 ] &&
  printf '%s\n' "$auth_status" | grep -Eiq \
    'workspace[[:space:]_:-]+[^[:space:]]+'; then
  workspace_ready=1
else
  workspace_ready=0
fi

if [ "$workspace_ready" -ne 1 ]; then
  fail \
    'no workspace could be resolved from PLANE_WORKSPACE or the active profile.' \
    'Set PLANE_WORKSPACE to the workspace slug, or select a profile that defines a workspace.'
fi

printf '%s\n' 'Plane CLI preflight: OK - executable, version, authentication, instance URL, and workspace are ready.'
