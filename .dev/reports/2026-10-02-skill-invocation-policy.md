# Explicit skill invocation policy

Date: 2026-10-02

## Changes

- Added `project-onboarding/agents/openai.yaml` with `policy.allow_implicit_invocation: false`. The skill requires an explicit user invocation in Codex.
- Kept implicit selection available for the other five shipped skills.
- Added optional `--manual-only` to the Bash skill generator, with a reusable policy asset. The default generator behavior still allows implicit selection and never overwrites an existing directory.
- Extended validation to check the repository's invocation-policy convention: block mapping, two-space indentation, and unquoted booleans. Duplicate or misplaced invocation flags are rejected. This remains a limited convention check rather than a full YAML parser.
- Updated AGENTS, onboarding instructions, the skill-creation workflow, README, adoption instructions, and skill/verification documentation.
- Extended behavioral coverage from 40 to 50 scenarios.

## Usage

Invoke onboarding explicitly in a project containing this template:

```text
$project-onboarding Adapt this project for the following product: ...
```

Create a new skill that requires explicit invocation:

```bash
bash .dev/scripts/new-skill.sh deliberate-workflow --description 'Perform this workflow when explicitly invoked.' --manual-only
```

For an existing skill, add `agents/openai.yaml` with:

```yaml
policy:
  allow_implicit_invocation: false
```

## Verification

The aggregate check passed, including all 50 behavioral scenarios and ShellCheck 0.11.0. The new scenarios cover default generation, explicit-only generation, option ordering, invalid/duplicate options, overwrite refusal, and invalid policy values/placement. Six skill frontmatter files passed the installed skill-creator validator. Both policy files were independently parsed as YAML and their values verified as boolean `false`. Local documentation links resolve.

The policy is configured according to the [official OpenAI skill documentation](https://learn.chatgpt.com/docs/build-skills#optional-metadata). Host enforcement has not been exercised in a fresh Codex session with this repository: the current chat is attached to AgentGame. The policy controls automatic skill selection, not repository access or tool authorization. Other hosts need their own compatible invocation-policy support.
