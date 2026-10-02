# Verification

## Entry point

`bash .dev/scripts/check.sh` validates configuration and required documentation, checks Bash syntax, validates skill metadata and unfinished drafts, runs the Bash behavioral suite, runs ShellCheck when available, then executes registered product checks. It records each step in `.dev/artifacts/check-report.md` and returns nonzero if any required step fails. An invalid configuration stops execution before any hooks run.

The aggregate continues after an individual check fails so the report includes subsequent check results. Individual hooks run in a fresh Bash with `errexit`, `nounset`, and `pipefail`; an internal failure cannot be hidden by a later successful command unless the hook deliberately handles it.

## Modes and coverage

- `template`: no product checks are required. Passing proves only the configured template checks passed.
- `project`: at least one declared check function is required. The function's usefulness and coverage still need review.

`CHECK_TIMEOUT_SECONDS` bounds each setup or product-check hook (1–3600 seconds). Timeouts return 124 and terminate the direct hook shell. A hook that starts background services must clean up its child processes; the runner is not a process-group supervisor. Foreground `dev.sh` is not time-bounded.

The default behavioral suite uses temporary local repositories and mock GitHub/package-manager commands. It checks failure propagation, argument handling, repository selection, Markdown body preservation, skill generation, timeout behavior, and aggregation. It installs no tools and performs no remote writes.

Skill validation checks repository frontmatter conventions, draft markers, and invocation-policy booleans in optional `agents/openai.yaml` files. It is not a full YAML parser or an evaluation of agent behavior. Use simple single-line frontmatter scalars and exercise skills with realistic tasks when refining them.

## Lint and CI

ShellCheck is optional locally and required in CI. Run `doctor.sh --lint` to enforce its presence. The linter follows available sources; SC1091 is excluded because scripts resolve dynamic paths, and SC2034 is excluded because configuration variables are consumed by other scripts.

The GitHub Actions workflow runs on pushes, pull requests, and manual dispatch. It installs ShellCheck on Ubuntu, runs doctor with the lint gate, runs the same aggregate check, and uploads the report even when checks fail. No secrets are needed for these template checks. Branch protection must be configured separately in GitHub to require a successful check before merge.

Adopting projects must add their actual toolchain installation and product checks. CI success does not establish browser appearance, native packaging, deployment, or a live authenticated Issues operation unless those checks are explicitly implemented and exercised.
