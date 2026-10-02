# Agent skills

Skills live in `.agents/skills/<name>/SKILL.md`, which compatible coding agents discover from the repository. Each file has YAML frontmatter with `name` and `description`, followed by a concise workflow. The description states both capability and when to invoke it.

| Skill | Responsibility | Codex invocation |
| --- | --- | --- |
| project-onboarding | Adapt context, hooks, tool requirements, and CI for a new project. | Explicit only |
| github-issues | Read tasks and perform authorized Issue operations. | Explicit or implicit |
| domain-modeling | Define concepts and invariants before implementation. | Explicit or implicit |
| diagnose-bug | Reproduce, diagnose, fix, and verify defects. | Explicit or implicit |
| review-change | Inspect changes and report actionable findings. | Explicit or implicit |
| create-project-skill | Reuse, scaffold, refine, and validate repository skills. | Explicit or implicit |
| handoff | Capture task state for continuation in another session or by another agent. | Explicit only |

Repository-wide paths mentioned by a skill are relative to the repository root. Its own assets or references are relative to the skill directory. Other agents may need explicit configuration for this location; this template does not assume every tool shares the same discovery convention.

## Invocation policy

Codex reads optional invocation policy from a skill's `agents/openai.yaml`:

```yaml
policy:
  allow_implicit_invocation: false
```

`false` disables automatic selection based on a matching task description; an explicit `$skill-name` invocation remains available. Omitting the setting defaults to `true`. This policy governs skill selection, not tool permissions or remote-write authorization. It does not prevent ordinary file reads or revoke the agent's access to the repository.

The shipped `project-onboarding` and `handoff` skills are explicit-only. Start them with:

```text
$project-onboarding Adapt this project for the following product: ...
$handoff Prepare a handoff for continuing issue 123 in a new session.
```

Other shipped skills keep Codex's default implicit selection. This is Codex metadata; other agent hosts must support their own equivalent policy to enforce the same behavior.

For repository validation, use a block-style `policy:` mapping, two-space indentation, and unquoted `true` or `false`. The Bash validator checks this convention and rejects malformed or duplicate invocation flags; it does not parse the complete YAML metadata schema.

## Task handoff

`handoff` uses its `assets/handoff.md.template` to write a concise English snapshot to `.dev/artifacts/agent/<task-id>/handoff.md`. It records the goal, current changes, observed verification, open questions, and next step. It references existing task and project records to keep context compact.

Handoff creation is explicit. Existing documents are refreshed only when requested; otherwise a unique task ID prevents overwriting earlier snapshots. To continue, give the next agent the path and the intended task. See [the handoff workflow](workflow.md#handoff-and-continuation).

## Create a skill

```bash
bash .dev/scripts/new-skill.sh example-workflow --description 'Perform a repeated project workflow when its trigger occurs.'
```

To create a draft that requires explicit invocation:

```bash
bash .dev/scripts/new-skill.sh deliberate-workflow --description 'Perform a workflow explicitly requested by the user.' --manual-only
```

The flag generates `agents/openai.yaml` from `assets/openai.yaml.template`. Without the flag, no policy file is generated and Codex's default implicit selection remains available. Existing skill directories are never overwritten.

The generator uses `.agents/skills/create-project-skill/assets/SKILL.md.template`, escapes apostrophes in the YAML description, and refuses to overwrite an existing directory. Complete the workflow and remove `SKILL_DRAFT`. The scaffold is intentionally invalid for delivery until it is completed.

```bash
bash .dev/scripts/validate-skills.sh .agents/skills/example-workflow
bash .dev/scripts/check.sh
```

Use lowercase hyphenated names up to 63 characters. Keep metadata on single lines and use a single-quoted description. Add supporting scripts, references, or assets only when they serve the workflow. Choose explicit-only invocation for deliberate entry points and implicit selection for supporting workflows. Place authorization checks next to actions that need them.

Metadata checks are not behavioral evaluations. Exercise the skill with representative requests and verify its evidence selection, scope, authorization handling, and outputs. Refine an existing skill rather than accumulating overlapping instructions.

See the official [skill authoring guide](https://learn.chatgpt.com/docs/build-skills) for discovery and progressive disclosure conventions.
