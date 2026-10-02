---
name: domain-modeling
description: 'Define or refine domain concepts, terminology, relationships, and invariants before implementation. Use when discussing the subject domain, adding glossary entries, or resolving conflicting meanings in a project.'
---

# Domain modeling

Read `docs/project.md`, `docs/glossary.md`, and relevant accepted decisions first.

1. Begin with one concise definition of the concept in the domain's language.
2. Explain its boundary using a concrete example and a counterexample. Establish relationships and invariants only when they clarify that boundary.
3. Separate accepted definitions, proposed alternatives, and open questions. Do not present a hypothesis as an agreed rule.
4. Keep conceptual definitions free of storage, transport, framework, and runtime choices unless the user asks for implementation.
5. Once agreed, update `docs/glossary.md` in English. Keep one canonical meaning per term and cross-reference related terms.
6. Use an ADR when a consequential choice needs its alternatives and rationale preserved; avoid creating an ADR for every definition.
7. When implementation is requested, map behavior and constraints to existing code and meaningful tests. Check the glossary still describes the implemented semantics.

For a game project, distinguish authoritative world state, an entity's knowledge, and claims made by another entity. Do not collapse these into one kind of fact without an explicit domain decision.
