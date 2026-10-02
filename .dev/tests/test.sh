#!/usr/bin/env bash
# Behavioral checks use temporary repositories and mocked external commands.
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../scripts/lib/common.sh"
[[ $# == 0 ]] || { error 'Usage: test.sh'; exit 2; }
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
fixture="$tmp/project with spaces"
mkdir -p -- "$fixture" "$tmp/bin" "$tmp/isolated-bin"
cp -R -- "$PROJECT_ROOT/.dev" "$PROJECT_ROOT/.agents" "$PROJECT_ROOT/docs" "$PROJECT_ROOT/.github" "$fixture/"
cp -- "$PROJECT_ROOT/README.md" "$PROJECT_ROOT/AGENTS.md" "$fixture/"
rm -rf -- "$fixture/.dev/artifacts"
export MOCK_GH_LOG="$tmp/gh.log" MOCK_BODY_COPY="$tmp/body.copy" MOCK_GH_FAILURE=''
cat > "$tmp/bin/gh" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' 'CALL' "$@" >> "$MOCK_GH_LOG"
if [[ $1 == auth && $2 == status && $MOCK_GH_FAILURE == auth ]]; then exit 1; fi
if [[ $1 == repo && $MOCK_GH_FAILURE == repo ]]; then exit 1; fi
if [[ $1 == issue && $MOCK_GH_FAILURE == write ]]; then exit 17; fi
for ((i=1;i<$#;i++)); do
  if [[ ${!i} == --body-file ]]; then j=$((i+1)); cp -- "${!j}" "$MOCK_BODY_COPY"; fi
done
if [[ $1 == repo ]]; then printf 'true\n'; else printf 'mock result\n'; fi
MOCK
chmod +x "$tmp/bin/gh"
# Explicitly isolate missing-tool and installer cases, even on a machine with gh installed.
for utility in bash dirname git head awk grep sed cat mkdir mktemp sleep rm cp chmod ln; do
  ln -s -- "$(command -v "$utility")" "$tmp/isolated-bin/$utility"
done
export PATH="$tmp/bin:$PATH"
script="$fixture/.dev/scripts"
config="$fixture/.dev/project.sh"
count=0
expect_status() {
  local expected=$1 actual=0; shift
  "$@" > "$tmp/output" 2>&1 || actual=$?
  if [[ $actual != "$expected" ]]; then
    printf 'FAIL: expected exit %s, got %s: %s\n' "$expected" "$actual" "$*" >&2
    cat "$tmp/output" >&2; exit 1
  fi
  count=$((count+1))
}
assert_contains() {
  if ! grep -Fq -- "$2" "$1"; then printf 'FAIL: missing text: %s\n' "$2" >&2; cat "$1" >&2; exit 1; fi
}
reset_config() {
  cat > "$config" <<'CONFIG'
PROJECT_NAME='test-project'
PROJECT_STAGE='template'
REQUIRED_TOOLS=(git)
PROJECT_CHECKS=()
CHECK_TIMEOUT_SECONDS=3
ISSUE_REPOSITORY='example/target'
CONFIG
}
reset_config
expect_status 0 bash "$script/doctor.sh"
expect_status 0 bash "$script/setup.sh"
expect_status 1 bash "$script/dev.sh"
assert_contains "$tmp/output" 'Define project_dev'
printf '\nREQUIRED_TOOLS=(missing-tool-for-template-test)\n' >> "$config"
expect_status 1 bash "$script/doctor.sh"
reset_config
printf '\nPROJECT_STAGE=project\n' >> "$config"
expect_status 1 bash "$script/check.sh"
assert_contains "$tmp/output" 'requires at least one real product check'
reset_config
printf '\nPROJECT_CHECKS=(undefined_check)\n' >> "$config"
expect_status 1 bash "$script/doctor.sh"
reset_config
printf '\nstrict_check() { false; printf should-not-run; }\nPROJECT_CHECKS=(strict_check)\n' >> "$config"
expect_status 1 bash "$script/lib/run-hook.sh" 3 strict_check
if grep -Fq 'should-not-run' "$tmp/output"; then error 'Hook lost errexit behavior'; exit 1; fi
printf '\nPROJECT_CHECKS=(strict_check strict_check)\n' >> "$config"
expect_status 1 bash "$script/doctor.sh"
reset_config
printf '\ntimeout_check() { while :; do :; done; }\nPROJECT_CHECKS=(timeout_check)\n' >> "$config"
expect_status 124 bash "$script/lib/run-hook.sh" 1 timeout_check
reset_config
# Literal hook source for the fixture.
# shellcheck disable=SC2016
printf '\nproject_dev() { printf "argument=<%%s>\\n" "$1"; }\n' >> "$config"
expect_status 0 bash "$script/dev.sh" 'two words'
assert_contains "$tmp/output" 'argument=<two words>'
reset_config
expect_status 1 env PATH="$tmp/isolated-bin" bash "$script/issues.sh" status
assert_contains "$tmp/output" 'Missing tool: gh'
: > "$MOCK_GH_LOG"
expect_status 2 bash "$script/issues.sh" create --title 'No body'
[[ ! -s $MOCK_GH_LOG ]] || { error 'Invalid arguments reached GitHub'; exit 1; }
export MOCK_GH_FAILURE=auth
expect_status 1 bash "$script/issues.sh" status
assert_contains "$tmp/output" 'authentication is unavailable'
export MOCK_GH_FAILURE=repo
expect_status 1 bash "$script/issues.sh" status
assert_contains "$tmp/output" 'Cannot access example/target'
export MOCK_GH_FAILURE=''
expect_status 0 bash "$script/issues.sh" status
expect_status 0 bash "$script/issues.sh" list --state all --label 'needs design' --limit 5
expect_status 0 bash "$script/issues.sh" view 12
assert_contains "$MOCK_GH_LOG" '--comments'
assert_contains "$MOCK_GH_LOG" 'example/target'
body="$tmp/issue body.md"
# Verify literal shell syntax survives body handling.
# shellcheck disable=SC2016
printf '# Task\n\nKeep literal $HOME and `backticks`.\nSecond paragraph.\n' > "$body"
expect_status 0 bash "$script/issues.sh" create --title 'Test task' --body-file "$body" --label 'task label'
cmp -- "$body" "$MOCK_BODY_COPY"
expect_status 0 bash "$script/issues.sh" comment 12 --body-file "$body"
cmp -- "$body" "$MOCK_BODY_COPY"
expect_status 0 bash "$script/issues.sh" edit 12 --body-file "$body" --add-label 'ready'
expect_status 0 bash "$script/issues.sh" close 12 --reason completed
expect_status 2 bash "$script/issues.sh" close 12
expect_status 2 bash "$script/issues.sh" view 0
expect_status 2 bash "$script/issues.sh" create --title ok --body-file "$tmp/missing"
export MOCK_GH_FAILURE=write
expect_status 17 bash "$script/issues.sh" comment 12 --body-file "$body"
export MOCK_GH_FAILURE=''
printf '\nISSUE_REPOSITORY=""\n' >> "$config"
git -C "$fixture" init -q
for remote in 'https://github.com/example/from-origin.git' 'git@github.com:example/from-origin.git' 'ssh://git@github.com/example/from-origin.git'; do
  git -C "$fixture" config remote.origin.url "$remote"
  expect_status 0 bash "$script/issues.sh" view 12
  assert_contains "$MOCK_GH_LOG" 'example/from-origin'
done
git -C "$fixture" config remote.origin.url 'https://invalid.example/repo'
expect_status 1 bash "$script/issues.sh" status
reset_config
expect_status 0 bash "$script/new-skill.sh" example-skill --description "User's workflow & trigger"
assert_contains "$fixture/.agents/skills/example-skill/SKILL.md" "User''s workflow & trigger"
[[ ! -e $fixture/.agents/skills/example-skill/agents/openai.yaml ]] || { error 'Default generation unexpectedly disabled implicit invocation'; exit 1; }
expect_status 1 bash "$script/new-skill.sh" example-skill --description 'Another description'
expect_status 2 bash "$script/new-skill.sh" '../escape' --description 'Invalid name'
expect_status 1 bash "$script/validate-skills.sh"
sed -i '/SKILL_DRAFT/d' "$fixture/.agents/skills/example-skill/SKILL.md"
expect_status 0 bash "$script/validate-skills.sh"
sed -i 's/name: example-skill/name: incorrect-name/' "$fixture/.agents/skills/example-skill/SKILL.md"
expect_status 1 bash "$script/validate-skills.sh"
rm -rf -- "$fixture/.agents/skills/example-skill"
# Explicit-only generation must preserve manual access through valid Codex metadata.
expect_status 0 bash "$script/new-skill.sh" manual-skill --manual-only --description 'Explicit workflow'
metadata="$fixture/.agents/skills/manual-skill/agents/openai.yaml"
assert_contains "$metadata" 'allow_implicit_invocation: false'
sed -i '/SKILL_DRAFT/d' "$fixture/.agents/skills/manual-skill/SKILL.md"
expect_status 0 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
expect_status 1 bash "$script/new-skill.sh" manual-skill --description 'Replacement' --manual-only
assert_contains "$metadata" 'allow_implicit_invocation: false'
expect_status 2 bash "$script/new-skill.sh" unknown-option --description 'Invalid' --unknown
expect_status 2 bash "$script/new-skill.sh" duplicate-option --description 'Invalid' --manual-only --manual-only
[[ ! -e $fixture/.agents/skills/unknown-option && ! -e $fixture/.agents/skills/duplicate-option ]] || { error 'Invalid options created a skill'; exit 1; }
printf 'policy:\n  allow_implicit_invocation: "false"\n' > "$metadata"
expect_status 1 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
printf 'policy:\n  allow_implicit_invocation: false\n  allow_implicit_invocation: true\n' > "$metadata"
expect_status 1 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
printf 'interface:\n  allow_implicit_invocation: false\n' > "$metadata"
expect_status 1 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
printf 'policy: {allow_implicit_invocation: false}\n' > "$metadata"
expect_status 1 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
printf 'policy:\n  allow_implicit_invocation: true\n' > "$metadata"
expect_status 0 bash "$script/validate-skills.sh" "$fixture/.agents/skills/manual-skill"
rm -rf -- "$fixture/.agents/skills/manual-skill"
# Installer test uses a mock Homebrew and isolated PATH; no packages or credentials change.
cat > "$tmp/isolated-bin/brew" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' "$*" >> "$MOCK_GH_LOG"
[[ $1 == install && $2 == gh ]]
cp -- "$MOCK_GH_SCRIPT" "$(dirname -- "${BASH_SOURCE[0]}")/gh"
MOCK
chmod +x "$tmp/isolated-bin/brew"
export MOCK_GH_SCRIPT="$tmp/bin/gh"
: > "$MOCK_GH_LOG"
expect_status 0 env PATH="$tmp/isolated-bin" bash "$script/setup.sh"
[[ ! -s $MOCK_GH_LOG ]] || { error 'Default setup installed a tool'; exit 1; }
expect_status 0 env PATH="$tmp/isolated-bin" bash "$script/setup.sh" --install-gh
assert_contains "$MOCK_GH_LOG" 'install gh'
expect_status 0 bash "$script/setup.sh" --github
assert_contains "$MOCK_GH_LOG" 'login'
# Prevent recursion in the copied aggregate check. Its own suite already ran above.
printf '#!/usr/bin/env bash\nexit 0\n' > "$fixture/.dev/tests/test.sh"
printf '#!/usr/bin/env bash\nexit 0\n' > "$tmp/bin/shellcheck"
chmod +x "$tmp/bin/shellcheck"
reset_config
printf '\nPROJECT_STAGE=project\nfirst_check() { false; }\nsecond_check() { printf second-ran; }\nPROJECT_CHECKS=(first_check second_check)\n' >> "$config"
expect_status 1 bash "$script/check.sh"
assert_contains "$tmp/output" 'second-ran'
assert_contains "$fixture/.dev/artifacts/check-report.md" '| Product: first_check | FAIL (1) |'
assert_contains "$fixture/.dev/artifacts/check-report.md" '| Product: second_check | PASS |'
reset_config
expect_status 0 bash "$script/check.sh"
assert_contains "$fixture/.dev/artifacts/check-report.md" 'No application behavior is verified.'
printf 'PASS: %s behavioral scenarios (external commands mocked).\n' "$count"
