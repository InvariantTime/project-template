---
name: domain-modeling
description: 'Define or refine domain concepts, terminology, relationships, and invariants before implementation. Use when establishing or changing canonical domain meanings, adding glossary entries, or resolving conflicting terminology in a project.'
---

# Domain modeling

Read `docs/project.md`, `docs/glossary.md`, and relevant accepted decisions first.

Use `domain-discussion` for exploratory assessment of an existing or proposed model: tradeoffs, alternatives, scenarios, and unresolved questions. This skill establishes precise meanings and records agreed changes. Use `domain-explainer` when the user needs an explanation of current knowledge. A discussion or visual explanation alone does not establish acceptance.

1. Begin with one concise definition of the concept in the domain's language.
2. Explain its boundary using a concrete example and a counterexample. Establish relationships and invariants only when they clarify that boundary.
3. Separate accepted definitions, proposed alternatives, and open questions. Do not present a hypothesis as an agreed rule.
4. Keep conceptual definitions free of storage, transport, framework, and runtime choices unless the user asks for implementation.
5. Once the meaning is agreed and the user has explicitly requested writing or updating the canonical documents, update `docs/glossary.md` in English. Defining or agreeing on a meaning in chat alone does not authorize file edits. Carry an existing document-edit request forward without repeated confirmation; do not infer acceptance from silence. Keep one canonical meaning per term and cross-reference related terms.
6. When the user requested recording decisions, use an ADR for a consequential choice whose alternatives and rationale need to persist. Otherwise propose the record in chat; avoid creating an ADR for every definition.
7. When implementation is requested, apply `.agents/skills/implement/SKILL.md` to map behavior and constraints to existing code and meaningful tests. Check the glossary still describes the implemented semantics.

For a game project, distinguish authoritative world state, an entity's knowledge, and claims made by another entity. Do not collapse these into one kind of fact without an explicit domain decision.
