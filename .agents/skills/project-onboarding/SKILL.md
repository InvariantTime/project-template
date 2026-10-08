---
name: project-onboarding
description: 'Adapt this template for a concrete project by defining domain context, development hooks, tool requirements, and CI checks. Use when adopting the template or establishing a new project workflow.'
---

# Project onboarding

Use only when the user explicitly invokes this skill. Its `agents/openai.yaml` disables implicit selection in Codex. Apply `AGENTS.md` change authorization: a request to adapt the repository permits the scoped changes below; an invocation asking only to discuss adoption permits analysis without edits. Apply `.agents/skills/implement/SKILL.md` for requested script, configuration, or other code changes.

1. Read `AGENTS.md`, `docs/project.md`, `docs/glossary.md`, `.dev/project.sh`, and `.dev/docs/adoption.md` from the repository root.
2. Establish the intended product, current scope, and actual stack from the user's request and repository evidence. Ask only for missing decisions that block implementation; record unresolved choices explicitly.
3. Replace template domain entries with the project's concepts. Put environment procedures in `.dev/docs/`, product explanations in `docs/`, and durable architectural decisions in `docs/decisions/`.
4. Add real tool requirements and named check functions to `.dev/project.sh`. Add `project_setup` and `project_dev` only when their commands exist. Hooks run from the root; use a subshell for a subdirectory.
5. Set `PROJECT_STAGE=project` once real checks are registered. This gate requires a check, but cannot judge whether that check is meaningful. Review the check against product behavior.
6. Adapt `.github/workflows/ci.yml` to install the stack and call the same check entry point. Keep credentials out of repository files.
7. Run doctor, setup, and check. Report which product behavior was actually verified and what still requires a browser, runtime, or external service.

Use GitHub's template creation flow for an independent new repository. Set its origin or `ISSUE_REPOSITORY` to the new repository before using the Issues helper. Do not create a repository or configure remote credentials unless the user has authorized it.
