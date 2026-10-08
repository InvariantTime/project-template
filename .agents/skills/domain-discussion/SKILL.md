---
name: domain-discussion
description: 'Evaluate existing or proposed domain models through tradeoffs, concrete scenarios, focused questions, and possible next steps. Use when the user wants to discuss a model, compare alternatives, or explore unresolved domain assumptions.'
---

# Discuss a domain model

Help the user assess a model and choose what to explore next. This skill allows implicit selection. The result can be a useful assessment with unresolved questions; agreement is not a completion requirement.

Use `domain-modeling` to establish precise canonical meanings and record agreed changes. Use `domain-explainer` to present the discussion clearly. Do not turn every explanation into a model discussion.

## Ground the discussion

1. Read `AGENTS.md`, `docs/project.md`, `docs/glossary.md`, and relevant accepted decisions. Read architecture or implementation only when a claim depends on them. For a supplied Issue, read its description and relevant comments. In template mode, discuss the template's domain or label a user-supplied product model as a proposal; do not invent an adopted product.
2. State the question the model should answer and the user's goal. Restate the model briefly in its own terms: concepts, boundaries, relationships, and rules. Distinguish the current accepted model from a new proposal, observed behavior, and unknowns. Cite the sources that support the assessment. If the goal is unclear, give a provisional assessment and ask about the goal.
3. Keep the discussion conceptual unless the user asks for implementation. Do not infer object layouts, storage, APIs, frameworks, or runtime infrastructure from a domain proposal.

## Assess and explore

4. Identify meaningful strengths and weaknesses against the stated goal. For each, explain the consequence and the condition under which it matters. Test terminology, responsibility boundaries, consistency, invariants, and whether the model represents required scenarios. Do not invent flaws or force equal numbers of pros and cons. Label unsupported concerns as hypotheses.
5. Walk through one concrete scenario and the most useful edge case or counterexample. Show which rule applies and where the model leaves an answer unclear. If sources or code contradict a claim, state the discrepancy without silently changing the accepted model. In a game domain, preserve the distinction between authoritative world state, entity knowledge, and claims unless an explicit domain decision changes it.
6. Compare a small number of plausible alternatives only when they address a concrete weakness. State what each improves, what it costs, and what must be true for it to work. Prefer a small refinement when it meets the goal; do not replace the user's model merely to impose a preferred design.
7. Suggest one to three possible next steps in order of value. Each step should name the uncertainty it resolves and a way to resolve it, such as clarifying a term, walking through a scenario, or comparing two rules. These are options, not an accepted roadmap. Recommend implementation or product tests only when that work is in scope.

## Continue the conversation

8. Give a useful assessment before asking questions. Ask the most consequential unanswered question next, usually one at a time. Explain which choice depends on the answer. Offer concise alternatives when helpful and allow a different answer. Do not ask for information already available in the sources, repeat a resolved question, or send a long questionnaire.
9. After the user answers, revise the affected assessment and move to the next uncertainty. Preserve unresolved assumptions. Follow a request to conclude, change direction, or leave a question open. When concluding, summarize the current judgment, remaining uncertainty, and recommended next step without requiring full agreement.

## Compose with the other domain skills

Read `.agents/skills/domain-explainer/SKILL.md` and apply it in the same session to present the model, scenario, or comparison. Pass the question, relevant source references, the accepted/proposed/unknown labels, the tradeoffs, and the next question into the explanation. Preserve those labels in every diagram, HTML page, or interactive visual. A visual must not make a proposal look like an accepted rule.

Choose the smallest useful output using that skill's rules. A compact assessment and diagram normally suffice. Create a larger guide or a supported native interactive visual when the user requests that artifact or visual output and the scope benefits from it. Without that request, keep the assessment in chat. Reuse a requested artifact for follow-up edits; do not build a new page for each question. Keep the next discussion question visible in chat even when the detailed assessment is an artifact.

Discussion alone does not authorize changes to the glossary or accepted decisions. When the user asks to define a chosen meaning, read `.agents/skills/domain-modeling/SKILL.md` and apply its conceptual workflow in chat. When the user explicitly requests recording or updating that meaning in canonical documents, read `.agents/skills/domain-modeling/SKILL.md` and apply it to that scope. Existing authorization carries forward; do not ask again for a write the user already requested. Do not infer acceptance from silence or interest in an option. Remote writes require authorization for the relevant operation.

## Review the result

Check that claims have sources or explicit hypothesis labels, each concern has a concrete consequence, scenarios respect accepted rules, and next steps address the stated goal. Verify that questions target real unresolved choices and that visual delivery follows `domain-explainer`. State material evidence limits. File review and illustrative scenarios do not establish product runtime behavior.
