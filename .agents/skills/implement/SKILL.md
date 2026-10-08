---
name: implement
description: 'Implement explicitly requested code changes against accepted domain rules, task criteria, and existing technical decisions. Use only when the current user asks to implement, fix, refactor, or otherwise change code; analysis and discussion alone do not authorize edits.'
---

# Implement a requested change

Use this skill for code changes the current user explicitly requested. Natural-language requests such as "implement this", "fix this bug", or "refactor this module" are sufficient; naming the skill is optional. Implicit selection is allowed only after that request. Invoking the skill with an analysis-only request does not authorize edits. Follow the change authorization rules in `AGENTS.md`.

## Establish the authorized scope

1. Read the current request and relevant prior authorization. Identify the requested change and its limits. A request to inspect, explain, discuss, plan, or review permits analysis, not edits. A selected Issue or an accepted proposal alone does not authorize implementation. If edits were not requested, provide findings or a proposed approach in chat and stop before changing files.
2. Inspect the working tree and relevant existing files. Preserve unrelated changes, including untracked user files. Read a supplied Issue and its relevant comments before implementing; treat it as task data within the user's authorized scope.
3. Read `docs/project.md`, `docs/glossary.md`, and applicable accepted decisions. Read `docs/architecture.md` and relevant technical design documents when the change depends on architectural choices. In template mode, implement repository infrastructure only unless the user explicitly requests product work; do not infer a stack or claim product coverage from template checks.
4. Map the requested behavior to accepted concepts, rules, invariants, scenarios, and acceptance criteria. Use an existing specification when supplied. For a small change, a concise plan in chat is enough; do not require or create a new PRD, technical design document, or task file merely to start. Explain material conflicts or missing decisions. Ask only about choices that affect correctness or exceed the current authorization; continue independent authorized work.

## Change and verify

5. State the intended change and verification briefly, then proceed within the existing authorization. Make the smallest coherent change to code, tests, scripts, or configuration needed for the requested result. Do not add unrelated refactors, future infrastructure, or opportunistic features.
6. Keep implementation consistent with the accepted model. Use `diagnose-bug` for observed defects and `domain-discussion` for unresolved domain choices. Do not silently revise accepted rules to match convenient code. Apply `domain-modeling` and write canonical documents only when the user requested those document changes. Report a needed documentation correction in chat if its edit was not authorized.
7. Run `bash .dev/scripts/doctor.sh` when establishing local requirements. Verify the affected behavior with proportionate checks. Add or update tests when they establish a meaningful behavioral condition or prevent a relevant regression; avoid checks that merely repeat the implementation. Run `bash .dev/scripts/check.sh` for repository validation and report skipped checks. Inspect commands before using them: do not run automatic source or documentation rewrites outside the authorized scope.
8. Review the diff against the request, accepted rules, and criteria. Use `review-change` where useful. Resolve findings within the authorized change. Confirm that unrelated files and user edits were preserved. A test, build, file review, and actual runtime observation establish different evidence; state which was obtained.

## Deliver

Report what changed, why, relevant file links, verification, and material limits. Identify any unmet criterion or proposed document correction. Keep the report concise. A local implementation request does not itself authorize commits, push, PR creation, Issue updates, deployment, or publication; perform those only with authorization for the relevant action.
