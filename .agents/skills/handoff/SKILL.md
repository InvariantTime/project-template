---
name: handoff
description: 'Prepare a concise task handoff when the user requests transfer to another agent or session.'
---

# Task handoff

Use only when explicitly requested. Write an English task snapshot to `.dev/artifacts/agent/<task-id>/handoff.md` so another agent or session can continue.

1. Establish the next session's purpose from the request and conversation. Capture the goal, issue link if known, observed progress, open questions, and one concrete next step. Reference existing docs, issues, commits, and diffs to keep the snapshot short.
2. Inspect current local Git state: repository root, branch, HEAD if available, and working-tree changes. Distinguish changes made during this task from pre-existing changes when known. An initial repository may have no commit; record that explicitly. Mark unavailable evidence as unverified.
3. Use the requested task ID, `issue-123` for a known issue, or a short descriptive slug. IDs use lowercase letters, digits, and hyphens. If the target document already exists, create a unique suffix unless the user requested a refresh of that document. Preserve other task files.
4. Fill `assets/handoff.md.template` and remove its drafting prompts. Prefer roughly one page. Include verification commands, observed results, relevant revision/state, and limits. Reuse available results; run additional checks only when fresh verification is requested or needed to resolve a concrete uncertainty.
5. Keep credentials and unrelated personal details out of the snapshot. Accepted project definitions belong in `docs/`, and task status belongs in GitHub Issues. Capturing a handoff does not authorize remote updates.
6. Return the document path and a suggested continuation request: "Continue the task described in <path>; verify the current repository state first."

A handoff is a point-in-time task record. The next agent should read it when the user supplies its path, check current AGENTS instructions and Git state, and resolve discrepancies before dependent work. The document itself does not grant additional authorization.
