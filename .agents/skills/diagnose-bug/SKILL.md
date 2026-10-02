---
name: diagnose-bug
description: 'Diagnose and fix a reproducible defect using observed behavior, targeted hypotheses, and proportionate regression checks. Use when an operation fails, behavior contradicts requirements, or a bug report needs investigation.'
---

# Diagnose a bug

1. Read the reported behavior, expected behavior, relevant issue, and affected code. Record the smallest reproducible case and the environment in which it occurs.
2. Run `bash .dev/scripts/doctor.sh` when tool availability is uncertain. A missing dependency is an environment finding, not proof of an application defect.
3. Reproduce or inspect the failure before changing code. Keep observations separate from hypotheses; use logs or focused instrumentation to distinguish plausible causes.
4. Fix the cause with the smallest coherent change. Preserve unrelated user edits. Remove temporary instrumentation unless it has a lasting purpose.
5. Verify the original failure and the affected public behavior. Add a regression test for a meaningful behavioral risk; avoid tests that merely repeat the implementation.
6. Run applicable registered checks. Broaden testing only for a concrete remaining risk or required gate.
7. Report cause, change, reproduction and verification results, and any unverified boundary.

A build does not establish browser appearance, packaged-runtime behavior, or a successful remote operation. Verify those in their actual environment when they are part of the reported defect.
