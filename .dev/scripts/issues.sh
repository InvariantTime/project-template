#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
load_project
usage() {
  cat <<'USAGE'
Usage: issues.sh status
       issues.sh list [--state open|closed|all] [--label LABEL] [--limit NUMBER]
       issues.sh view NUMBER
       issues.sh create --title TITLE --body-file FILE [--label LABEL ...]
       issues.sh comment NUMBER --body-file FILE
       issues.sh edit NUMBER [--title TITLE] [--body-file FILE] [--add-label LABEL ...]
       issues.sh close NUMBER --reason completed|not-planned
Writes require authorization in the current task. Body files preserve Markdown and newlines.
USAGE
}
[[ $# -gt 0 ]] || { usage >&2; exit 2; }
action=$1; shift
command_args=()
body_files=()
number() { [[ $1 =~ ^[1-9][0-9]*$ ]] || { error 'Issue number must be a positive integer'; exit 2; }; }
value() { [[ $# -ge 2 && -n $2 ]] || { error "Missing value for $1"; exit 2; }; }
case "$action" in
  status) [[ $# == 0 ]] || { usage >&2; exit 2; } ;;
  view)
    [[ $# == 1 ]] || { usage >&2; exit 2; }
    number "$1"; command_args=(issue view "$1" --comments)
    ;;
  list)
    command_args=(issue list)
    while (( $# )); do
      value "$@"
      case $1 in
        --state) [[ $2 == open || $2 == closed || $2 == all ]] || { error 'Invalid issue state'; exit 2; } ;;
        --label) ;;
        --limit) [[ $2 =~ ^[1-9][0-9]{0,3}$ ]] || { error 'Invalid list limit'; exit 2; } ;;
        *) usage >&2; exit 2 ;;
      esac
      command_args+=("$1" "$2"); shift 2
    done
    ;;
  create|comment|edit)
    command_args=(issue "$action")
    if [[ $action != create ]]; then
      [[ $# -ge 1 ]] || { usage >&2; exit 2; }
      number "$1"; command_args+=("$1"); shift
    fi
    has_title=false; has_body=false; has_edit=false
    while (( $# )); do
      value "$@"
      case $1 in
        --title)
          [[ $action != comment ]] || { usage >&2; exit 2; }
          has_title=true
          ;;
        --body-file) body_files+=("$2"); has_body=true ;;
        --label) [[ $action == create ]] || { usage >&2; exit 2; } ;;
        --add-label) [[ $action == edit ]] || { usage >&2; exit 2; } ;;
        *) usage >&2; exit 2 ;;
      esac
      has_edit=true
      command_args+=("$1" "$2"); shift 2
    done
    if [[ $action == create && ( $has_title != true || $has_body != true ) ]] ||
       [[ $action == comment && $has_body != true ]] ||
       [[ $action == edit && $has_edit != true ]]; then
      usage >&2; exit 2
    fi
    ;;
  close)
    [[ $# == 3 && $2 == --reason && ( $3 == completed || $3 == not-planned ) ]] || { usage >&2; exit 2; }
    number "$1"; command_args=(issue close "$1" --reason "$3")
    ;;
  *) usage >&2; exit 2 ;;
esac
for body_file in "${body_files[@]}"; do
  [[ -f $body_file && -r $body_file && -s $body_file ]] || { error "Body file must be readable and nonempty: $body_file"; exit 2; }
done
repo=$(github_ready)
if [[ $action == status ]]; then
  printf 'GitHub Issues target: %s\n' "$repo"
  gh repo view "https://github.com/$repo" --json hasIssuesEnabled --jq .hasIssuesEnabled
else
  gh "${command_args[@]}" --repo "github.com/$repo"
fi
