# Architecture

## Current structure

This repository is development infrastructure for a future product. There is no application architecture yet.

`.dev/project.sh` supplies trusted Bash configuration and named hooks. Entry-point scripts resolve the root from their own location, so they work from any current directory. Local verification combines template integrity checks, development-script behavioral tests, optional ShellCheck, and registered product checks.

`.agents/skills/` contains project workflows for compatible coding agents. `.github/workflows/ci.yml` invokes the same verification entry point used locally. GitHub Issues hold task records; repository documentation holds product knowledge and durable decisions.

## Boundaries

- Configuration and hooks are executable repository code; inspect them before running an untrusted checkout.
- Template mode validates infrastructure. Project mode requires registered product checks; meaningful coverage still requires review.
- Development hooks run in the foreground. Bounded check hooks terminate their direct shell on timeout; hooks that launch background services must arrange cleanup of their children.
- The Issues helper targets github.com and passes an explicit repository to every operation.

When adopting the template, document the actual application modules, their responsibilities, dependencies, and constraints here. Keep environment commands in `.dev/docs/`.
