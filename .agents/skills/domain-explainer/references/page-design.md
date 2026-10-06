# Design an HTML domain explanation

Use this guide only for the HTML route. A focused question normally needs short text and a diagram in chat.

## Content

- Start with the question and its answer.
- Use short sections. Keep about 80% of authored prose in the ASD-STE100 style described in `SKILL.md`. Do not calculate a compliance score.
- Use one concrete example across the page when possible.
- Keep important conditions visible. Use section links or `details` for optional depth.
- Label examples, proposals, and unknowns where they appear. Add source references beside claims and a compact source list.
- Explain terms before using them in a diagram or control. A large topic needs more structure, not longer sentences.

## Black theme

- Use a black page background, such as `#000000`, and dark panels, such as `#111111`.
- Use light primary text, such as `#f2f2f2`, and readable secondary text, such as `#b8b8b8`.
- Use a restrained accent color for links, focus, and the relevant part of a visual. Color must not be the only signal.
- Use system fonts, a clear heading hierarchy, comfortable line lengths, and space between sections.
- Design for desktop. Do not add mobile breakpoints, alternate phone diagrams, or print styles unless requested.

## Visuals and interaction

| Question | Useful visual |
| --- | --- |
| How are concepts related? | A labeled SVG diagram |
| What happens next? | Stages, transitions, or an animated sequence |
| What changes under an assumption? | A small interactive scenario |
| How do cases differ? | A comparison diagram or table |
| What does a spatial concept mean? | An annotated illustration |

Illustrations, animation, and interaction can carry the explanation. They need not be limited to decoration. Choose them when they reduce the text needed to understand the question.

- Label nodes, edges, stages, and controls. Include a short text explanation of their meaning.
- State what a scenario changes and what it keeps fixed. Label illustrative outputs.
- Use buttons, radios, selects, and native disclosures when suitable. Avoid drag-only controls.
- Show one change at a time in an animated sequence. Provide pause or replay for long sequences and honor reduced motion where applicable.
- Use accessible SVG titles or image alt text, visible focus, and semantic HTML. Use `textContent` for dynamic text.
- Keep the answer readable without JavaScript. Use local assets and inline code instead of CDNs, remote fonts, or runtime fetches.

## Lightweight review

Read the files to check source accuracy, labels, internal links, asset paths, and interaction logic. Fix clear errors found in this review. Do not add a browser test, local server, screenshot pass, mobile calculation, or mandatory language checker. Do not claim visual or runtime verification from file review.
