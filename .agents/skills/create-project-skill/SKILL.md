---
name: create-project-skill
description: 'Create or refine a reusable repository skill for a repeated project workflow, using the local scaffold and validation conventions. Use when the user asks for a skill or a recurring workflow would materially benefit from dedicated agent instructions.'
---

# Create a project skill

Read `.dev/docs/skills.md` and inspect existing `.agents/skills/` before adding another skill. Extend an existing skill if its trigger and responsibility already cover the workflow.

1. Identify a concrete repeated workflow. Define the capability and the requests that should trigger it. Do not create a skill for every one-off task.
2. When the user explicitly requests creating a skill, run:

   ```bash
   bash .dev/scripts/new-skill.sh skill-name --description 'Capability and when to use it.'
   ```

   Add `--manual-only` when the user wants explicit invocation only or the workflow is a deliberate entry point such as onboarding. It writes the Codex policy from `assets/openai.yaml.template`.

3. Complete the generated `SKILL.md`. Use project-specific steps, evidence sources, stop conditions, and verification boundaries. Keep the frontmatter `name` and `description` as single-line scalars; the name must match the directory.
4. Add scripts, references, or assets only when they remove repeated work. Resolve supporting paths relative to the skill. Link repository-wide context from the repository root.
5. Choose invocation deliberately. Allow implicit selection for reusable supporting workflows; use `--manual-only` for workflows that should start only when explicitly requested. Put authorization checks immediately before remote writes or other restricted actions; invocation policy does not authorize those actions.
6. Remove `SKILL_DRAFT` and every unresolved placeholder once instructions are complete. Run `validate-skills.sh` and `check.sh`.
7. Exercise the workflow against a realistic request. Metadata validation does not prove agent behavior: inspect that it selects the right evidence, obeys authorization, and produces the intended outcome. Report anything not exercised.

The scaffold refuses an existing directory. Edit an existing skill when the user requests that refinement rather than overwriting it through generation. An identified workflow improvement alone is a proposal, not authorization to create or edit skill files. Consult `assets/SKILL.md.template` when changing the scaffold itself.
