# Adopt the template

1. Publish this repository and enable **Template repository** in its GitHub settings. Use **Use this template** to create each new project. This step is performed only when repository publication is authorized.
2. Clone the new repository. To run agent-guided adaptation, explicitly invoke `$project-onboarding`; it is not selected automatically. Inspect `.dev/project.sh` before executing it, then run doctor and check to verify the starting infrastructure.
3. Replace `docs/project.md`, `docs/glossary.md`, and `docs/architecture.md` with the product's actual context. Adjust `AGENTS.md` only for project-specific requirements.
4. Set `PROJECT_NAME` and `REQUIRED_TOOLS` in `.dev/project.sh`. Define real setup, development, and verification functions. Use function names in `PROJECT_CHECKS`.
5. Set `PROJECT_STAGE=project` once real checks exist. An empty check list is rejected in project mode. Do not add `true` or a message-only function to pass this gate.
6. Adapt CI to install the project's toolchain and dependency versions before calling `check.sh`. Put required checks here; delivery and deployment workflows depend on the actual product and are added later.
7. Enable GitHub Issues. Configure an authenticated account and the new repository's origin, or set `ISSUE_REPOSITORY`. Verify the target with `issues.sh status` before writing tasks.
8. Retain useful skills, refine project-specific workflows, and remove unused ones. At least one completed skill must remain for template validation.
9. Review the old work report as historical template evidence; remove it from the new project if it adds no useful context. Update the README's link accordingly.

## Hook example

Use only commands that exist in the adopted project:

```bash
PROJECT_NAME='example-product'
PROJECT_STAGE='project'
REQUIRED_TOOLS=(git dotnet pnpm)
PROJECT_CHECKS=(backend_tests frontend_types)
CHECK_TIMEOUT_SECONDS=300
ISSUE_REPOSITORY=''

project_setup() {
  dotnet restore backend/Example.sln
  (cd frontend && pnpm install --frozen-lockfile)
}
project_dev() { (cd frontend && pnpm dev "$@"); }
backend_tests() { dotnet test backend/Example.sln --no-restore; }
frontend_types() { (cd frontend && pnpm typecheck); }
```

The example is not the template's selected stack. Pin the adopted toolchain in its own manifests and CI setup steps. Generated repositories do not automatically receive future template changes; review and port useful updates deliberately.
