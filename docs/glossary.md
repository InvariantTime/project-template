# Domain glossary

Keep one canonical definition per term. Define what a concept means in the domain before discussing its representation or implementation. Mark proposed meanings and unresolved questions explicitly.

The entries below describe the template's current domain. An adopting product should replace them with its own concepts; this is not a Realmix domain specification.

| Term | Definition | Boundary |
| --- | --- | --- |
| Project template | A reusable starting point from which an independent project is created. | It supplies initial conventions, not an implemented product. |
| Project | A coordinated effort to build and maintain a product with a defined purpose and scope. | Its domain and requirements belong to that product. |
| Issue | A tracked unit of work or discussion with an identifiable purpose. | An issue may describe a defect, capability, or question; it is not proof that work is complete. |
| Acceptance criterion | An observable condition used to decide whether intended work is complete. | A command passing is relevant only if it establishes that condition. |
| Decision | An accepted choice with a recorded rationale and consequences. | A proposal or open question is not an accepted decision. |

## Entry format for product concepts

Use a heading for a concept that needs more detail: definition, example, boundary or counterexample, related concepts, and open questions when applicable. Keep API types, database schemas, and deployment details in architecture documentation.
