# GitHub Issues

GitHub Issues are the main task tracker. Local docs capture product knowledge and decisions, not a second copy of task status.

## Readiness and target

The helper uses GitHub CLI. Configure authentication and access using [the environment guide](environment.md), then:

```bash
bash .dev/scripts/issues.sh status
bash .dev/scripts/issues.sh list --state open --limit 20
bash .dev/scripts/issues.sh view 12
```

`view` includes comments. The target is `ISSUE_REPOSITORY` from `.dev/project.sh`, otherwise an HTTPS or SSH github.com origin. Every operation passes an explicit github.com URL or host-qualified repository, so gh's ambient repository and host selection do not redirect it. GitHub Enterprise is not supported by this helper.

`status` reports the target and the repository's `hasIssuesEnabled` value. If it prints `false`, enable Issues in that repository before using issue operations. Access preflight verifies authentication and repository visibility, not write permission; an attempted authorized operation can still fail due to permission or disabled Issues. CLI errors propagate to the caller.

## Authorized writes

Write the exact Markdown body into a file. This preserves paragraphs and avoids shell expansion of body content.

```bash
bash .dev/scripts/issues.sh create --title 'Implement the first playable interaction' --body-file /tmp/task.md
bash .dev/scripts/issues.sh comment 12 --body-file /tmp/progress.md
bash .dev/scripts/issues.sh edit 12 --body-file /tmp/revised-task.md --add-label ready
bash .dev/scripts/issues.sh close 12 --reason completed
```

Prepare these files first; the paths above are examples, not supplied files. The helper also accepts `--label` on creation, `--title` on editing, and `--reason not-planned` on closure. Labels must exist in the target repository. `edit --body-file` replaces the body: reread and preserve unrelated content first.

Remote writes require the user's authorization for the relevant operation. Do not create, comment on, edit, or close an issue merely because local implementation is complete. After an ambiguous write failure, reread the current state before retrying to avoid duplication.

## Task contents

Use `.github/ISSUE_TEMPLATE/task.md`: problem, scope, acceptance criteria, dependencies, and verification plan. PR descriptions link the issue and state observed results and limitations. Closing a task requires its acceptance criteria to be satisfied, not just a passing template check.

CLI option references: [create](https://cli.github.com/manual/gh_issue_create), [view](https://cli.github.com/manual/gh_issue_view), [edit](https://cli.github.com/manual/gh_issue_edit), [authentication](https://cli.github.com/manual/gh_auth_status).
