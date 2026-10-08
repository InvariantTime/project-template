# Agent skills

Skills live in `.agents/skills/<name>/SKILL.md`, which compatible coding agents discover from the repository. Each file has YAML frontmatter with `name` and `description`, followed by a concise workflow. The description states both capability and when to invoke it.

| Skill | Responsibility | Codex invocation |
| --- | --- | --- |
| project-onboarding | Adapt context, hooks, tool requirements, and CI for a new project. | Explicit only |
| github-issues | Read tasks and perform authorized Issue operations. | Explicit or implicit |
| domain-discussion | Assess models, tradeoffs, scenarios, unresolved questions, and possible next steps. | Explicit or implicit |
| domain-modeling | Establish precise concepts and invariants and record agreed meanings before implementation. | Explicit or implicit |
| domain-explainer | Explain domain questions with a diagram, a black-theme HTML guide, or a native interactive visual in supported ChatGPT/Codex sessions. | Explicit or implicit |
| diagnose-bug | Reproduce, diagnose, fix, and verify defects. | Explicit or implicit |
| implement | Implement explicitly requested code changes and verify them against accepted rules and task criteria. | Explicit or implicit after a user code-change request |
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

## Requested implementation

`AGENTS.md` requires a user request before creating or changing repository code or documentation. Inspection, diagnosis, planning, review, and agreement on a model leave files unchanged. Natural-language requests count; the user does not need to name a skill. Existing authorization remains valid for the scoped task, so do not ask for repeated approval.

Use `implement` after an explicit code-change request. It reads the accepted domain model and relevant technical decisions, maps them to the requested behavior and verification, implements the scoped change, and reviews the result. Implicit selection is permitted only after the user's request authorizes code changes. A small change does not require a new PRD or technical design document. Documentation edits need a request covering those edits; otherwise report the needed correction in chat. `diagnose-bug` and `review-change` can feed findings into implementation when the user requested a fix.

```text
$implement Implement the behavior described by issue 123. Preserve the accepted domain rules.
Fix the missing-hook error in the development script.
Review this change and report findings without editing files.
Update the glossary with the agreed definition; leave code unchanged.
```

Verification output in disposable local directories is distinct from source and documentation edits. Follow `AGENTS.md` for artifact creation, and report skipped or unverified checks. Commit, push, Issue writes, and publication require their own authorization.

## Domain discussion and modeling

Use `domain-discussion` to assess an existing model or a user proposal. It identifies strengths, weaknesses, concrete consequences, and unresolved assumptions. It uses scenarios to test boundaries, suggests possible next steps, and asks one focused question at a time. It can finish with open questions; a discussion does not need to force agreement.

The three domain skills have different outcomes:

| Request | Skill | Outcome |
| --- | --- | --- |
| Does this model fit our goal? What are its weaknesses? | `domain-discussion` | An assessment, alternatives, and the next question or step |
| Define this concept and record the agreed meaning. | `domain-modeling` | Precise meanings, relationships, and invariants; authorized canonical updates |
| How does this concept or rule work? | `domain-explainer` | A concise visual explanation with source references |

`domain-discussion` reads and applies `domain-explainer` in the same session for presentation. It uses that skill's existing diagram, HTML, and supported native visualization routes, rather than duplicating their rendering rules. Proposed alternatives remain labeled as proposals. The next discussion question stays visible in chat. A request to define a selected meaning uses `domain-modeling` in chat; a request to record it authorizes the canonical document edit; exploratory discussion alone does not change canonical documents.

```text
$domain-discussion Assess our current Issue model. What works, where are its boundaries unclear, and what should we clarify next?
$domain-discussion Compare the current acceptance-criterion definition with this proposal: any passing command means the work is complete.
$domain-modeling Define the agreed meaning of acceptance criterion and record it in the glossary.
```

## Domain explanation pages

Use `domain-explainer` for a question about a project concept, rule, relationship, or scenario. A focused answer uses short text and a diagram. A larger explanation can use a separate HTML page with a black theme when the user requests an artifact. Without that request, keep the explanation in chat. Pages can include illustrations, navigation, animation, and interaction. Keep prose concise and aim to use ASD-STE100 principles for about 80% of authored explanation text, without a compliance calculation. Accepted definitions, proposals, unknowns, and examples remain distinct. Defining or changing a canonical concept belongs to `domain-modeling`.

When the user requests visual output, ChatGPT and Codex may instead deliver a native interactive visual in chat when interaction makes the answer clearer. This route requires both the matching agent host and an explicitly available visualization capability with a native rendering contract. An OpenAI model alone does not enable it. Other agents and unsupported sessions keep the diagram or separate HTML routes. The skill reads its OpenAI-specific reference only after these checks pass and uses the installed host instructions for rendering. Simple static explanations still use a diagram; an explicit request for an HTML file still produces a separate black-theme page.

```text
$domain-explainer What is an acceptance criterion? Give a short answer and a diagram.
$domain-explainer Explain how acceptance criteria relate to verification and Issue completion. Build a visual HTML guide with a worked example.
```

Pages default to `.dev/artifacts/domain-explanations/<topic>/index.html`, with inline styles, scripts, and SVG where practical. They need no build or external dependencies. An artifact request authorizes creating the output; a general question alone does not. The agent reviews sources and files, then returns the result. Mobile layouts and browser verification are not part of this workflow. Follow-up edits reuse the requested page. These artifacts are ignored by Git and capture a point-in-time explanation; request a tracked documentation destination when the guide should be versioned. This workflow does not publish a website or update canonical definitions automatically.

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
