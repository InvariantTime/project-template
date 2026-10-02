#!/usr/bin/env bash
# Repository convention: frontmatter name/description are single-line YAML scalars.
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
[[ $# -le 1 ]] || { error 'Usage: validate-skills.sh [SKILL_DIRECTORY]'; exit 2; }
if [[ $# == 1 ]]; then
  directories=("$1")
else
  shopt -s nullglob
  directories=("$PROJECT_ROOT"/.agents/skills/*/)
fi
[[ ${#directories[@]} -gt 0 ]] || { error 'No project skills found'; exit 1; }
# Validate only the invocation policy convention, not the full metadata schema.
# Policy blocks use two-space indentation and unquoted YAML booleans.
validate_invocation_policy() {
  awk '
    {
      sub(/[[:space:]]+#.*$/, "")
      if ($0 ~ /^[[:space:]]*(#.*)?$/) next
    }
    /^policy[[:space:]]*:/ {
      if ($0 !~ /^policy:[[:space:]]*$/ || ++policies > 1) exit 1
      in_policy=1
      next
    }
    /^[^[:space:]]/ { in_policy=0 }
    /^[[:space:]]*allow_implicit_invocation[[:space:]]*:/ {
      if (!in_policy || $0 !~ /^  allow_implicit_invocation: (true|false)[[:space:]]*$/ || ++flags > 1) exit 1
    }
  ' "$1"
}
status=0
for directory in "${directories[@]}"; do
  directory=${directory%/}
  folder=${directory##*/}
  file="$directory/SKILL.md"
  if [[ ! -f $file ]]; then error "Missing $file"; status=1; continue; fi
  if [[ ! $folder =~ ^[a-z0-9]+(-[a-z0-9]+)*$ || ${#folder} -gt 63 ]]; then
    error "Invalid skill directory name: $folder"; status=1; continue
  fi
  if [[ $(head -n 1 "$file") != '---' ]] || [[ $(awk 'BEGIN {n=0} /^---$/ {n++; if(n==2) {print "closed"; exit}}' "$file") != closed ]]; then
    error "Missing YAML frontmatter delimiters: $file"; status=1; continue
  fi
  frontmatter=$(awk 'NR==1 {next} /^---$/ {exit} {print}' "$file")
  name=$(printf '%s\n' "$frontmatter" | sed -n 's/^name: //p')
  description=$(printf '%s\n' "$frontmatter" | sed -n 's/^description: //p')
  if [[ $name != "$folder" || -z $description || $description == "''" || $description == '""' || $description == '|' || $description == '>' ]]; then
    error "Expected matching name and nonempty single-line description: $file"; status=1; continue
  fi
  if grep -qE '^[[:space:]]*SKILL_DRAFT([:[:space:]]|$)|\{\{[A-Z_]+\}\}' "$file"; then
    error "Unfinished skill draft: $file"; status=1; continue
  fi
  metadata="$directory/agents/openai.yaml"
  if [[ -e $metadata || -L $metadata ]] && { [[ ! -f $metadata || ! -s $metadata ]] || ! validate_invocation_policy "$metadata"; }; then
    error "Invalid invocation policy: $metadata (use a policy block, two-space indentation, and true/false)"
    status=1; continue
  fi
  printf 'OK skill: %s\n' "$folder"
done
exit "$status"
