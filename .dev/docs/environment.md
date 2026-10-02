# Development environment

## Baseline

Use Bash 4.4+, Git, and standard Unix utilities (`awk`, `sed`, `grep`, `find`-style filesystem tools, `mktemp`, `cp`, and related commands). The scripts require no Python, jq, npm, or .NET runtime until an adopting project adds its stack.

Linux is the verified baseline and the CI platform. On macOS, use a recent Homebrew Bash rather than the system Bash 3.2. Windows contributors can use WSL or a sufficiently recent Git Bash. Those platforms have not been exercised in the template's local validation.

```bash
bash --version
bash .dev/scripts/doctor.sh
bash .dev/scripts/setup.sh
```

`REQUIRED_TOOLS` determines the local tool gate. Default setup checks tools, creates the ignored artifact directory, and calls `project_setup` if defined. It does not automatically install missing global tools. A project's setup hook may download its declared dependencies.

## Optional tool installation

```bash
bash .dev/scripts/setup.sh --install-gh
bash .dev/scripts/setup.sh --install-shellcheck
```

These explicit commands install the named tool through Homebrew or `apt-get` (using sudo when required). They may update package indexes and install system dependencies. Other package managers need manual installation following the [GitHub CLI instructions](https://github.com/cli/cli#installation) or [ShellCheck instructions](https://github.com/koalaman/shellcheck#installing).

A CLI executable, an authenticated account, and repository permission are separate requirements. If gh is unavailable, local development still works; the issue helper exits with setup guidance. Do not replace a failed GitHub write with an untracked local task and claim that it was published.

## GitHub authentication

```bash
bash .dev/scripts/setup.sh --github
bash .dev/scripts/doctor.sh --github
bash .dev/scripts/issues.sh status
```

`--github` invokes interactive `gh auth login --hostname github.com`; it does not install gh. For automation, use a supported `GH_TOKEN` supplied by the execution environment. Do not store a token in `.dev/project.sh`, `.env.example`, documentation, or issue bodies. Configure an origin remote or `ISSUE_REPOSITORY='owner/repository'` and ensure the account has the needed access. See [the issue workflow](github-issues.md).

## Troubleshooting

- Missing tool: install it explicitly, then rerun doctor.
- Old Bash: select a newer Bash executable in PATH.
- No development hook: implement `project_dev` using the application's actual startup command.
- Empty product checks: register meaningful check functions before selecting project mode.
- GitHub access failure: inspect account, network, target repository, and permissions; do not assume retrying will resolve it.
