#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
usage() { error 'Usage: new-skill.sh NAME --description "Capability and trigger" [--manual-only]'; }
[[ $# -ge 1 ]] || { usage; exit 2; }
name=$1; shift
description=''
description_set=false
manual_only=false
while (( $# )); do
  case $1 in
    --description)
      [[ $# -ge 2 && $description_set == false ]] || { usage; exit 2; }
      description=$2; description_set=true; shift 2
      ;;
    --manual-only)
      [[ $manual_only == false ]] || { usage; exit 2; }
      manual_only=true; shift
      ;;
    *) usage; exit 2 ;;
  esac
done
[[ $name =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#name} -le 63 ]] || { error 'Use a lowercase hyphenated name of at most 63 characters'; exit 2; }
[[ -n $description && $description != *$'\n'* && $description != *$'\r'* ]] || { error 'Description must be a nonempty single line'; exit 2; }
target="$PROJECT_ROOT/.agents/skills/$name"
[[ ! -e $target && ! -L $target ]] || { error "Skill already exists: $name"; exit 1; }
assets="$PROJECT_ROOT/.agents/skills/create-project-skill/assets"
template="$assets/SKILL.md.template"
[[ -f $template ]] || { error 'Missing skill template'; exit 1; }
if [[ $manual_only == true && ! -f $assets/openai.yaml.template ]]; then
  error 'Missing manual invocation policy template'; exit 1
fi
yaml_description=$(printf '%s' "$description" | sed "s/'/''/g")
content=$(cat "$template")
content=${content//\{\{NAME\}\}/"$name"}
content=${content//\{\{DESCRIPTION\}\}/"$yaml_description"}
# Atomic directory creation refuses a concurrent creator as well as an existing skill.
mkdir -- "$target"
printf '%s\n' "$content" > "$target/SKILL.md"
if [[ $manual_only == true ]]; then
  mkdir -- "$target/agents"
  cp -- "$assets/openai.yaml.template" "$target/agents/openai.yaml"
  printf 'Invocation: explicit only (Codex policy).\n'
else
  printf 'Invocation: implicit selection allowed (Codex default).\n'
fi
printf 'Created draft: .agents/skills/%s/SKILL.md\n' "$name"
printf 'Complete its workflow and remove SKILL_DRAFT before running check.sh.\n'
