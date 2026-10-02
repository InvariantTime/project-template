#!/usr/bin/env bash
# Run one trusted config function with a bounded duration.
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/common.sh"
load_project
[[ $# -ge 2 ]] || { error 'Usage: run-hook.sh SECONDS FUNCTION [ARGUMENTS...]'; exit 2; }
seconds=$1
hook=$2
shift 2
if [[ ! $seconds =~ ^[1-9][0-9]{0,3}$ ]] || (( seconds > 3600 )); then error 'Invalid timeout'; exit 2; fi
if [[ ! $hook =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] || ! declare -F "$hook" >/dev/null; then error "Undefined hook: $hook"; exit 2; fi
marker_dir=$(mktemp -d)
child=''
watcher=''
# Called indirectly by the EXIT trap; older ShellCheck versions flag the body as unreachable.
# shellcheck disable=SC2317,SC2329
cleanup() {
  [[ -z $watcher ]] || kill "$watcher" 2>/dev/null || true
  [[ -z $child ]] || kill "$child" 2>/dev/null || true
  rm -rf -- "$marker_dir"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
bash -e -u -o pipefail -c 'source "$1"; cd -- "$2"; hook=$3; shift 3; "$hook" "$@"' \
  bash "$CONFIG_FILE" "$PROJECT_ROOT" "$hook" "$@" &
child=$!
(
  for (( tick=0; tick<seconds; tick++ )); do
    sleep 1
    kill -0 "$child" 2>/dev/null || exit 0
  done
  : > "$marker_dir/timed-out"
  kill -TERM "$child" 2>/dev/null || true
  sleep 1
  kill -KILL "$child" 2>/dev/null || true
) &
watcher=$!
status=0
wait "$child" || status=$?
child=''
kill "$watcher" 2>/dev/null || true
wait "$watcher" 2>/dev/null || true
watcher=''
if [[ -f "$marker_dir/timed-out" ]]; then
  error "Hook $hook timed out after $seconds seconds"
  exit 124
fi
exit "$status"
