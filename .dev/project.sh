#!/usr/bin/env bash
# Trusted executable project configuration. Keep credentials outside this file.
PROJECT_NAME='project-template'
PROJECT_STAGE='template' # Change to project when real product checks are registered.
REQUIRED_TOOLS=(git)
PROJECT_CHECKS=() # Bash function names, e.g. (backend_tests frontend_types).
CHECK_TIMEOUT_SECONDS=300
ISSUE_REPOSITORY='' # Empty: infer owner/repository from the GitHub origin remote.

# Optional hooks: define only the hooks your project actually needs.
# project_setup() { pnpm install --frozen-lockfile; }
# project_dev() { pnpm dev; }
# backend_tests() { dotnet test backend/Realmix.sln; }
# frontend_types() { (cd frontend && pnpm typecheck); }
# Hook commands run from the repository root in a fresh Bash with errexit and pipefail.
