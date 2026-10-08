---
name: review-change
description: 'Review a change against its intended behavior, domain invariants, and project conventions, with actionable evidence. Use for code review, pre-merge review, or a user''s request to inspect recent changes.'
---

# Review a change

1. Read the current user request, `AGENTS.md`, applicable issue, and affected domain definitions. Determine the intended behavior and scope.
2. Inspect the working tree and untracked files. If a comparison base is provided, use it; otherwise explain the scope you can establish from local Git state. Do not assume an initial repository has a commit or remote.
3. Trace changed behavior through callers and consumers. Prioritize correctness, lost data, broken contracts, and concrete security or performance risks. Avoid speculative findings and style-only churn.
4. Use the smallest relevant check or reproduction to substantiate a suspected defect. A passing check does not dismiss an uncovered path.
5. Present findings ordered by severity, with exact file location, triggering condition, impact, and a suggested direction. Separate confirmed defects from unresolved questions.
6. If there are no actionable findings, say so and state the verification limits.

A review request authorizes inspection. Apply `.agents/skills/implement/SKILL.md` for fixes when the user also asks for them; otherwise deliver findings. Remote PR comments and issue updates require authorization for those writes.
