# AI-first project template

A repository template for projects developed with people and coding agents. It supplies project context, reusable agent workflows, Bash development entry points, and a GitHub Issues workflow.

This repository has no application yet. Its default checks validate the template and its development scripts. Each new project must register its own product checks.

## Layout

```text
AGENTS.md               Short agent entry point
README.md               Human entry point
docs/                   Product context, domain glossary, architecture, decisions
.dev/                   Development configuration, scripts, guides, tests, reports
.agents/skills/         Discoverable project skills and skill scaffold
.github/                CI and issue/PR templates
```

Product source and test directories belong to the adopting project's stack. Existing empty `src/` and `tests/` directories are optional starting points.

## Start here

Requires Bash 4.4+, Git, and standard Unix utilities.

```bash
bash .dev/scripts/doctor.sh
bash .dev/scripts/setup.sh
bash .dev/scripts/check.sh
```

The generated check report is `.dev/artifacts/check-report.md` (ignored by Git). Install ShellCheck to enable local linting; CI requires it.

For task continuation, explicitly request `$handoff`. It writes a concise local snapshot under `.dev/artifacts/agent/<task-id>/`; see [handoff and continuation](.dev/docs/workflow.md#handoff-and-continuation).

```bash
bash .dev/scripts/setup.sh --install-shellcheck
bash .dev/scripts/setup.sh --install-gh
bash .dev/scripts/setup.sh --github
bash .dev/scripts/issues.sh list
```

Tool installation is explicit. GitHub operations additionally require an authenticated account and a repository target. Default setup installs nothing until you define a project dependency hook.

## Adopt the template

Use GitHub's **Use this template** flow after enabling **Template repository** in repository settings. Then follow the [adoption guide](.dev/docs/adoption.md) to define the product and its commands. A generated repository is an independent copy; later template changes are not inherited automatically.

Start agent-guided adaptation explicitly with `$project-onboarding` and the product description. This skill does not start automatically. New skills can opt into the same policy with `new-skill.sh --manual-only`; see [Agent skills](.dev/docs/skills.md).

Ask `$domain-explainer` to answer a focused domain question with short text and a diagram, or a larger question with a black-theme HTML guide. Guides can include illustrations, animation, and interaction. HTML guides are local artifacts by default; see [domain explanation pages](.dev/docs/skills.md#domain-explanation-pages).

- [Project context](docs/project.md) and [domain glossary](docs/glossary.md)
- [Development workflow](.dev/docs/workflow.md) and [environment setup](.dev/docs/environment.md)
- [Verification](.dev/docs/verification.md)
- [GitHub Issues](.dev/docs/github-issues.md)
- [Agent skills](.dev/docs/skills.md)
- [Work report](.dev/reports/2026-10-02-template-update.md)

All documentation, README content, skills, and repository templates use English. User-facing conversation can use the user's language.
