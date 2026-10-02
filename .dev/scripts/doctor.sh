#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
profile=${1:-local}
[[ $# -le 1 && ( $profile == local || $profile == --github || $profile == --lint ) ]] || {
  error 'Usage: doctor.sh [--github|--lint]'; exit 2;
}
load_project
status=0
printf 'Project: %s (%s)\nBash: %s\n' "$PROJECT_NAME" "$PROJECT_STAGE" "$BASH_VERSION"
for tool in "${REQUIRED_TOOLS[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf 'OK      %s\n' "$tool"
  else
    printf 'MISSING %s (required for local work)\n' "$tool"
    status=1
  fi
done
for tool in gh shellcheck; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf 'OK      %s (available)\n' "$tool"
  else
    printf 'OPTIONAL %s (required only for its feature)\n' "$tool"
  fi
done
if [[ $profile == --github ]]; then
  if repo=$(github_ready); then printf 'OK      GitHub repository: %s\n' "$repo"; else status=1; fi
elif [[ $profile == --lint ]]; then
  require_tool shellcheck || status=1
fi
exit "$status"
