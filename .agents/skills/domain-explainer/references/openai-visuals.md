# Native interactive domain visuals

Read this reference only after the ChatGPT/Codex host and native rendering capability checks in `SKILL.md` pass. Other agents retain the portable diagram and separate HTML workflows.

## Use the host contract

Read the full installed visualization skill or equivalent host instructions before creating or revising the visual. Follow their current artifact format, storage location, rendering syntax, sizing, theme, accessibility, and delivery rules. Do not copy a renderer protocol or a machine-specific plugin path into this repository skill. Do not infer support from the underlying OpenAI model.

If those instructions are missing or do not provide native rendering in the current surface, return to the existing output routes. Availability can vary by platform, account, and workspace. See the [OpenAI visualization guide](https://learn.chatgpt.com/docs/visualizations).

The black theme and artifact path in `references/page-design.md` apply to separate HTML pages. Native visuals follow the host's presentation and storage contract; honor an explicit theme request where supported. Do not add a separate mobile layout or browser verification phase. Review sources and interaction logic, and perform any checks required by the active host contract. Report any material verification limit.

## Make interaction explain the domain

- Start from the user's question and a direct, short answer. Use established project sources as required by `SKILL.md`.
- Choose controls that reveal a relationship, transition, assumption, or consequence. A small process stepper or scenario explorer is often sufficient.
- Label inputs, states, and results. Preserve the project's terms. Keep accepted rules, examples, proposals, and unknowns distinct.
- State assumptions and limits near the controls. Simulated outputs illustrate the explanation; they do not prove product behavior.
- Keep the core explanation readable and controls accessible. Animation should help the reader follow a change.
- Keep explanatory prose concise, using the ASD-STE100 style preference in `SKILL.md`. Do not turn the visual into a full website when a compact explanation is enough.
- Keep interactions local to the explanation. Do not add publication, account access, Issue writes, or changes to canonical definitions.

Deliver through the native renderer, with only the brief text needed to use and interpret the visual. Do not deliver a local file link as though it were a native interactive visual. If the user requests a standalone file, use the separate HTML workflow instead.
