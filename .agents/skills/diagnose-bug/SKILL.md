---
name: diagnose-bug
description: 'Diagnose a reproducible defect and apply a fix only when requested, using observed behavior, targeted hypotheses, and proportionate regression checks. Use when an operation fails, behavior contradicts requirements, or a bug report needs investigation.'
---

# Diagnose a bug

Follow `AGENTS.md` change authorization. A failure report or a request to diagnose permits investigation, not source or documentation edits. Use existing logs and non-mutating inspection first. Temporary source instrumentation also requires a code-change request.

1. Read the reported behavior, expected behavior, relevant issue, and affected code. Record the smallest reproducible case and the environment in which it occurs.
2. Run `bash .dev/scripts/doctor.sh` when tool availability is uncertain. A missing dependency is an environment finding, not proof of an application defect.
3. Reproduce or inspect the failure before changing code. Keep observations separate from hypotheses; use logs or focused instrumentation to distinguish plausible causes.
4. If the user requested a fix, read `.agents/skills/implement/SKILL.md` and apply it within that scope to fix the cause with the smallest coherent change. Otherwise report the diagnosis and proposed fix without editing files. Preserve unrelated user edits. Remove temporary instrumentation unless it has a lasting purpose.
5. Verify the original failure and the affected public behavior using existing checks during diagnosis. When a fix is requested, add a regression test for a meaningful behavioral risk; avoid tests that merely repeat the implementation.
6. Run applicable registered checks. Broaden testing only for a concrete remaining risk or required gate.
7. Report cause, change, reproduction and verification results, and any unverified boundary.

A build does not establish browser appearance, packaged-runtime behavior, or a successful remote operation. Verify those in their actual environment when they are part of the reported defect.
