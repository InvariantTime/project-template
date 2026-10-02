#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
[[ $# == 0 ]] || { error 'Usage: check.sh'; exit 2; }
load_project
cd -- "$PROJECT_ROOT"
mkdir -p -- "$ARTIFACT_DIR"
report="$ARTIFACT_DIR/check-report.md"
{
  printf '# Verification report\n\n'
  # Backticks are literal Markdown delimiters.
  # shellcheck disable=SC2016
  printf 'Project: `%s`  \nStage: `%s`  \nRegistered product checks: %s\n\n' "$PROJECT_NAME" "$PROJECT_STAGE" "${#PROJECT_CHECKS[@]}"
  if [[ $PROJECT_STAGE == template ]]; then
    printf 'Template validation only. No application behavior is verified.\n\n'
  fi
  printf '| Check | Result |\n| --- | --- |\n'
} > "$report"
status=0
step() {
  local label=$1 result=0; shift
  printf '\nChecking: %s\n' "$label"
  "$@" || result=$?
  if (( result == 0 )); then
    printf '| %s | PASS |\n' "$label" >> "$report"
  else
    printf '| %s | FAIL (%s) |\n' "$label" "$result" >> "$report"
    status=1
  fi
}
required_files=(README.md AGENTS.md docs/README.md docs/project.md docs/architecture.md docs/glossary.md
  docs/decisions/README.md .dev/docs/adoption.md .dev/docs/environment.md .dev/docs/workflow.md
  .dev/docs/verification.md .dev/docs/skills.md .dev/docs/github-issues.md .github/workflows/ci.yml)
for file in "${required_files[@]}"; do step "File: $file" test -s "$file"; done
step 'Local tools' bash "$DEV_DIR/scripts/doctor.sh"
shopt -s globstar nullglob
scripts=("$DEV_DIR"/**/*.sh)
for script in "${scripts[@]}"; do step "Syntax: ${script#"$PROJECT_ROOT/"}" bash -n "$script"; done
step 'Skill metadata and drafts' bash "$DEV_DIR/scripts/validate-skills.sh"
step 'Development script behavior' bash "$DEV_DIR/tests/test.sh"
if command -v shellcheck >/dev/null 2>&1; then
  # Config declarations are consumed by dynamically sourced scripts.
  step 'ShellCheck' shellcheck --external-sources --source-path=SCRIPTDIR --exclude=SC1091,SC2034 "${scripts[@]}"
else
  printf '| ShellCheck | SKIP (not installed; required in CI) |\n' >> "$report"
  printf 'ShellCheck skipped locally. Run setup.sh --install-shellcheck to enable it.\n'
fi
for check_name in "${PROJECT_CHECKS[@]}"; do
  step "Product: $check_name" bash "$DEV_DIR/scripts/lib/run-hook.sh" "$CHECK_TIMEOUT_SECONDS" "$check_name"
done
printf '\nReport: .dev/artifacts/check-report.md\n'
exit "$status"
