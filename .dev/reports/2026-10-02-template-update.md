# AI-first template update report

Date: 2026-10-02  
Repository: `project-template`

## Result

The template now has English documentation, a domain glossary, configurable Bash development commands, six repository skills, a skill scaffold, and GitHub Issues tooling. CI runs the same verification entry point as local development.

The repository remains in template mode: there is no application or selected product stack. An adopting project must define its domain and register meaningful product checks.

## Changes

| Requested area | Implemented result |
| --- | --- |
| English documentation | Updated README, AGENTS, documentation, issue/PR templates, and environment comments. Removed references to the former bilingual and Python harness structure. |
| Domain glossary | Added `docs/glossary.md` with conceptual definitions, boundaries, and guidance for adopting projects. Current entries describe the template, not Realmix. |
| Bash scripts | Added the commands below, shared configuration, bounded hook execution, and a Bash behavioral suite. Runtime tooling requires no Python or jq. |
| Agent skills | Added onboarding, GitHub Issues, domain modeling, diagnosis, review, and skill creation workflows in `.agents/skills/`. |
| GitHub Issues | Added an explicit-target CLI helper, task template, PR template, environment instructions, and a dedicated skill. Issues are the main task source. |
| Skill scaffold | Added an asset template and generator that escapes YAML descriptions and refuses overwrites. Generated drafts must be completed before checks pass. |
| Verification and CI | Updated CI to Bash checks and ShellCheck, added report upload and GitHub Actions dependency updates. |
| Work report | Added this report; per-run verification output is generated separately and ignored by Git. |

Development material lives in `.dev/`. Product knowledge lives in `docs/`. The obsolete `docs/work/README.md` was removed to avoid a second task-status convention. Existing source/test directories and Git history were preserved.

## Development commands

| Command | Purpose |
| --- | --- |
| `bash .dev/scripts/doctor.sh` | Inspect required local tools and optional feature tools. |
| `bash .dev/scripts/doctor.sh --github` | Verify GitHub CLI, authentication, and repository visibility. |
| `bash .dev/scripts/doctor.sh --lint` | Require ShellCheck. |
| `bash .dev/scripts/setup.sh` | Verify local requirements and run a configured dependency hook. |
| `bash .dev/scripts/setup.sh --install-gh` | Explicitly install GitHub CLI through a supported package manager. |
| `bash .dev/scripts/setup.sh --install-shellcheck` | Explicitly install the linter. |
| `bash .dev/scripts/setup.sh --github` | Start interactive GitHub authentication and verify access. |
| `bash .dev/scripts/dev.sh` | Launch the configured application's foreground development hook. |
| `bash .dev/scripts/check.sh` | Run template checks and registered product checks; write a result report. |
| `bash .dev/scripts/issues.sh ...` | Inspect, create, comment on, edit, or close issues when authorized. |
| `bash .dev/scripts/new-skill.sh NAME --description '...'` | Create a skill draft from the repository scaffold. |
| `bash .dev/scripts/validate-skills.sh` | Check local skill metadata conventions and unfinished drafts. |

`.dev/project.sh` is trusted executable configuration. It defines the project stage, required tools, check functions, timeout, optional repository override, and optional setup/development hooks. Project mode rejects an empty product-check list.

## Verification performed

- Aggregate check: passed with ShellCheck enabled.
- Bash syntax: passed for all 11 configuration, script, and test files.
- Behavioral suite: **40 scenarios passed**, using temporary local repositories and mocked external commands.
- ShellCheck: passed using **0.11.0** extracted into a temporary directory. No global tool installation was performed.
- All six skills: passed the installed skill-creator metadata validator independently of the template's Bash validator.
- CI and Dependabot YAML: parsed and checked for the intended structure.
- Documentation links: checked locally for existing targets.
- Documentation, skills, templates, and scripts: checked for accidental remaining Cyrillic content.

Behavioral scenarios cover missing tools, missing development hooks, empty or invalid check registration, strict failure propagation, timeout exit codes, paths and arguments containing spaces, GitHub authentication/access failures, repository selection, Markdown body preservation, remote command error propagation, skill escaping and overwrite refusal, draft validation, explicit installer/authentication routes, and aggregate failure reporting.

The external-command tests do not install packages, authenticate a real account, or write to GitHub.

## Verification limits and next steps

1. GitHub CLI is absent from the current environment and the repository has no origin remote. Live authenticated issue operations remain unverified. Install gh, configure the real repository and account, then run `issues.sh status`.
2. The GitHub Actions workflow has been checked locally, but has not run on GitHub. Publish the repository and run CI before relying on it as a merge gate. Configure branch protection separately.
3. Bash 4.4+ is required. Linux was exercised; macOS and Windows variants have not been tested.
4. Skills were checked for metadata and reviewed for workflow scope. This is not a behavioral evaluation of an agent following each skill in a new session.
5. Product behavior is unverified because no application exists. Add real checks and switch to project mode when adopting the template.
6. Hook timeouts stop the direct shell. Hooks that start child services must manage their cleanup.
7. Template mode provides verification CI. Product deployment, package publication, and credentials depend on the adopted project and are not configured here.

## References used

- [Official skill authoring guide](https://learn.chatgpt.com/docs/build-skills)
- [GitHub CLI issue creation](https://cli.github.com/manual/gh_issue_create), [viewing](https://cli.github.com/manual/gh_issue_view), [editing](https://cli.github.com/manual/gh_issue_edit), and [authentication](https://cli.github.com/manual/gh_auth_status)
- [Checkout action v7.0.1](https://github.com/actions/checkout/releases/tag/v7.0.1)
- [Upload-artifact action documentation](https://github.com/actions/upload-artifact/tree/v7.0.1), including hidden-directory report uploads
