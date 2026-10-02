#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
load_project
[[ $# -le 1 ]] || { error 'Usage: setup.sh [--install-gh|--install-shellcheck|--github]'; exit 2; }
privileged() {
  if [[ $(id -u) == 0 ]]; then "$@"; else require_tool sudo; sudo -- "$@"; fi
}
install_tool() {
  local tool=$1
  if command -v "$tool" >/dev/null 2>&1; then printf '%s is already installed.\n' "$tool"; return; fi
  if command -v brew >/dev/null 2>&1; then
    brew install "$tool"
  elif command -v apt-get >/dev/null 2>&1; then
    privileged apt-get update
    privileged apt-get install -y "$tool"
  else
    error "No supported installer found for $tool. Use the official installation instructions in .dev/docs/environment.md."
    return 1
  fi
  require_tool "$tool"
}
case ${1:-local} in
  --install-gh) install_tool gh ;;
  --install-shellcheck) install_tool shellcheck ;;
  --github)
    require_tool gh
    gh auth login --hostname github.com
    bash "$DEV_DIR/scripts/doctor.sh" --github
    ;;
  local)
    bash "$DEV_DIR/scripts/doctor.sh"
    mkdir -p -- "$ARTIFACT_DIR"
    if declare -F project_setup >/dev/null; then
      bash "$DEV_DIR/scripts/lib/run-hook.sh" "$CHECK_TIMEOUT_SECONDS" project_setup
    else
      printf 'Template ready. Define project_setup in .dev/project.sh when dependencies exist.\n'
    fi
    ;;
  *) error 'Usage: setup.sh [--install-gh|--install-shellcheck|--github]'; exit 2 ;;
esac
