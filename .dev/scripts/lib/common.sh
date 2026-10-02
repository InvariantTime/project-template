#!/usr/bin/env bash
# Sourced by development entry points; Bash 4.4+ is required.
if (( BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4) )); then
  printf 'ERROR: Bash 4.4+ is required. Use a recent Bash, WSL, or Git Bash.\n' >&2
  exit 1
fi
DEV_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
PROJECT_ROOT=$(cd -- "$DEV_DIR/.." && pwd -P)
CONFIG_FILE="$DEV_DIR/project.sh"
ARTIFACT_DIR="$DEV_DIR/artifacts"
export DEV_DIR PROJECT_ROOT
error() { printf 'ERROR: %s\n' "$*" >&2; }
require_tool() {
  command -v "$1" >/dev/null 2>&1 || { error "Missing tool: $1. See .dev/docs/environment.md."; return 1; }
}
load_project() {
  [[ -f "$CONFIG_FILE" ]] || { error 'Missing .dev/project.sh'; return 1; }
  # shellcheck source=../../project.sh
  source "$CONFIG_FILE"
  [[ ${PROJECT_NAME:-} =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]] || { error 'Invalid PROJECT_NAME'; return 1; }
  [[ ${PROJECT_STAGE:-} == template || ${PROJECT_STAGE:-} == project ]] || { error 'PROJECT_STAGE must be template or project'; return 1; }
  [[ $(declare -p REQUIRED_TOOLS 2>/dev/null) == 'declare -a '* ]] || { error 'REQUIRED_TOOLS must be an array'; return 1; }
  [[ $(declare -p PROJECT_CHECKS 2>/dev/null) == 'declare -a '* ]] || { error 'PROJECT_CHECKS must be an array'; return 1; }
  if [[ ! ${CHECK_TIMEOUT_SECONDS:-} =~ ^[1-9][0-9]{0,3}$ ]] || (( CHECK_TIMEOUT_SECONDS > 3600 )); then
    error 'CHECK_TIMEOUT_SECONDS must be from 1 to 3600'; return 1
  fi
  [[ -z ${ISSUE_REPOSITORY:-} || $ISSUE_REPOSITORY =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]] || {
    error 'ISSUE_REPOSITORY must be owner/repository'; return 1;
  }
  local check_name tool seen=' '
  for tool in "${REQUIRED_TOOLS[@]}"; do
    [[ $tool =~ ^[a-zA-Z0-9._+-]+$ ]] || { error "Invalid tool name: $tool"; return 1; }
  done
  for check_name in "${PROJECT_CHECKS[@]}"; do
    [[ $check_name =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] || { error "Invalid check name: $check_name"; return 1; }
    [[ $seen != *" $check_name "* ]] || { error "Duplicate check: $check_name"; return 1; }
    seen+="$check_name "
    declare -F "$check_name" >/dev/null || { error "Check function is undefined: $check_name"; return 1; }
  done
  if [[ $PROJECT_STAGE == project && ${#PROJECT_CHECKS[@]} == 0 ]]; then
    error 'Project stage requires at least one real product check'; return 1
  fi
}
resolve_issue_repo() {
  local remote repo
  if [[ -n ${ISSUE_REPOSITORY:-} ]]; then
    printf '%s\n' "$ISSUE_REPOSITORY"; return
  fi
  remote=$(git -C "$PROJECT_ROOT" config --get remote.origin.url) || {
    error 'Set a GitHub origin remote or ISSUE_REPOSITORY in .dev/project.sh'; return 1;
  }
  case "$remote" in
    https://github.com/*) repo=${remote#https://github.com/} ;;
    git@github.com:*) repo=${remote#git@github.com:} ;;
    ssh://git@github.com/*) repo=${remote#ssh://git@github.com/} ;;
    *) error 'The issue helper supports github.com origin remotes. Set ISSUE_REPOSITORY explicitly.'; return 1 ;;
  esac
  repo=${repo%.git}
  [[ $repo =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]] || { error 'Cannot infer owner/repository from origin'; return 1; }
  printf '%s\n' "$repo"
}
github_ready() {
  require_tool gh || { printf 'Run bash .dev/scripts/setup.sh --install-gh, then --github.\n' >&2; return 1; }
  local repo
  repo=$(resolve_issue_repo) || return 1
  if ! gh auth status --hostname github.com >/dev/null 2>&1; then
    error 'GitHub authentication is unavailable. Run gh auth login --hostname github.com or configure GH_TOKEN.'; return 1
  fi
  if ! gh repo view "https://github.com/$repo" --json nameWithOwner --jq .nameWithOwner >/dev/null 2>&1; then
    error "Cannot access $repo. Check the account, repository permissions, network, and Issues settings."; return 1
  fi
  printf '%s\n' "$repo"
}
