#!/usr/bin/env bash
set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/lib/common.sh"
load_project
bash "$DEV_DIR/scripts/doctor.sh"
declare -F project_dev >/dev/null || { error 'Define project_dev in .dev/project.sh to launch the application'; exit 1; }
cd -- "$PROJECT_ROOT"
project_dev "$@"
