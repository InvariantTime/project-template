# Development workflow

## Start a task

Read the current request and applicable GitHub Issue, including acceptance criteria and comments. Read product context and relevant domain definitions. If no issue exists, implement work authorized by the user; publishing an issue is a separate authorized operation.

Run doctor when the environment is uncertain. Use setup after dependency or toolchain changes. Configure the application's development hook, then launch it with:

```bash
bash .dev/scripts/dev.sh
```

Arguments are passed to `project_dev`. The server runs in the foreground so normal terminal interruption remains available.

## Implement and verify

Keep changes within the intended scope. Update conceptual documentation when meanings change; record consequential decisions when their rationale needs to persist. Put repeatable development automation in `.dev/scripts/`.

Run focused checks during implementation, then:

```bash
bash .dev/scripts/check.sh
```

Read `.dev/artifacts/check-report.md`. Distinguish template checks, product checks, skipped linting, and behavior that needs a browser, native runtime, or external service. A generated report is disposable evidence and is ignored by Git.

## Finish a task

Summarize what changed, why, verification results, and material limits. Compare those results to acceptance criteria. Update or close the GitHub Issue when authorized. Do not mirror its status in `docs/work/` or another local task tracker.

Commit, push, PR creation, and deployment follow the user's authorization and the project's configured delivery process. This template provides validation CI; it does not deploy an unspecified product.

## Handoff and continuation

For a long task, switching agents, or continuing in a later session, explicitly request `$handoff` and describe what the next session should focus on. It saves `.dev/artifacts/agent/<task-id>/handoff.md` using the skill's template. Prefer one concise snapshot with references to the Issue, docs, changes, and verification results.

The directory is ignored by Git. Share the file explicitly when continuing on another machine or with another person. The next agent reads the supplied path and compares the snapshot with the current repository and user request before continuing. A handoff may be stale; record unavailable evidence and resolve discrepancies relevant to the next action.

Temporary task notes can live alongside the handoff when they help the work. Create them on demand. Keep accepted concepts and decisions in `docs/`, and task status in GitHub Issues. These files are local task context and are not loaded automatically as general user memory.

`.dev/artifacts/` also holds generated check reports and other disposable tool output. The legacy `.artifacts/` directory is ignored for compatibility and has no active writer in this template.
