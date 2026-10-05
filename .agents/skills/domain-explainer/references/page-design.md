# Designing a domain explanation page

Use this guide to choose the smallest presentation that makes the specific question understandable. The output is an educational document, not a new application or a fixed dashboard layout.

## Teaching structure

- Lead with the question and a direct answer. Give the reader a reason to explore the rest.
- Introduce terms just before they are needed. Connect each abstract rule to the same worked scenario so the reader can follow its consequences.
- Explain relationships, permitted changes, invariants, and boundaries only when relevant to the question. Include a near-miss example that shows where the concept stops applying.
- Offer progressive detail through section links and native `details` elements. Essential qualifications and the main answer must remain visible.
- Separate accepted rules from proposals and examples at the point of use. Show conflicting sources or unknowns explicitly. Put compact source references beside consequential claims, with paths and relevant supporting text in the sources section.

## Visual choices

| Reader's difficulty | Useful presentation | Required explanation |
| --- | --- | --- |
| Understanding relationships | Labeled SVG diagram | Text stating what the nodes and edges mean |
| Following a process | Numbered stages with an optional step control | Ordering, transition conditions, and exceptions |
| Comparing alternatives | Side-by-side examples or a table | Common comparison criteria and decision status |
| Understanding consequences | A small control that changes one assumption | What varies, what stays fixed, and why the output changes |
| Understanding space | An annotated illustration or map | Scale and which details are schematic |

Give every control an educational purpose. Prefer buttons, radios, selects, and native disclosures over drag-only interactions. Label illustrative calculations and scenarios; their outputs are not authoritative world state or proof that an Issue is complete.

## Presentation baseline

- Use a clear typographic hierarchy, comfortable line lengths, whitespace, and a restrained color palette. Important meaning must not depend on color alone.
- Set UTF-8, a meaningful document title, `lang`, and a viewport meta tag. Use one `h1`, logical section headings, landmarks, and a keyboard-accessible table of contents.
- Prefer inline SVG with accessible title/description and an adjacent text summary. Use meaningful alt text for other illustrations. Escape source text inserted into HTML; use `textContent` for dynamic text.
- Keep core content present in HTML. JavaScript can enhance a visual, but a failed script must not hide the answer. Use system fonts and local assets by default, avoiding remote fonts, CDNs, analytics, and runtime fetches.
- Make layouts wrap on narrow screens. Avoid clipped diagrams, fixed desktop widths, and sticky navigation that covers anchors or keyboard focus.
- Animate a visible change only to explain it. Provide pause/replay for long sequences, avoid autoplay loops, and honor `prefers-reduced-motion` in CSS and JavaScript when applicable.
- Provide print CSS that keeps the explanation and source references readable, removes purely interactive controls, and exposes necessary collapsed details. Provide static summaries for interactive scenarios.

## Browser acceptance pass

1. Open the delivered file, or its exact content served through a loopback-only server. Confirm the initial answer and sources are readable with no external requests needed.
2. Inspect a desktop width (about 1280 px) and a phone width (about 390 px). Look for overflow, covered anchors, illegible labels, and cramped controls.
3. Exercise navigation, disclosures, and all scenario controls. Verify results against the intended rules, including a boundary case. Inspect keyboard tab order and focus visibility.
4. Check reduced-motion presentation and print preview when the tool supports them. Check that the essential explanation remains available without JavaScript. Do not report unsupported checks as passed.
5. Fix observed defects and repeat the affected checks. Deliver the HTML with a concise record of actual checks and limitations; browser inspection of this page does not verify the product it explains.
