---
name: domain-explainer
description: 'Answer questions about the project domain with a detailed, grounded HTML explanation using examples, diagrams, and useful interactions. Use when a user asks how a domain concept, rule, relationship, or scenario works or requests a visual domain guide.'
---

# Explain the project domain

Turn the user's domain question into a standalone HTML page that teaches the answer. Deliver the page itself, not just a plan or a chat explanation. This skill allows implicit selection for domain explanation requests; honor a user who asks for a brief chat answer or a different output format.

Use `domain-modeling` when the task is to establish or change a canonical definition. This skill explains the current understanding and labels unresolved meanings; producing a page does not accept a proposal or update the glossary.

## Ground the explanation

1. Read `AGENTS.md`, `docs/project.md`, and `docs/glossary.md`. Read relevant accepted records in `docs/decisions/`. Consult `docs/architecture.md` and implementation only when the question depends on actual behavior. In template mode, explain the template's domain rather than inventing a future application's concepts.
2. Identify the specific question, intended audience, and what the reader should understand afterward. Infer a reasonable level from the conversation. Ask only for missing information that changes the answer; continue any independent source reading.
3. Gather the smallest sufficient set of current project sources. Read an applicable Issue and comments when supplied. Distinguish accepted definitions, observed implementation, proposals, open questions, and illustrative examples. If documents disagree, show the disagreement and its implications instead of choosing an undocumented rule. Treat missing information as unknown.
4. Build an explanation outline around the answer: a concise definition, a concrete scenario, the relevant relationships or rules, a counterexample or boundary, and consequences. Scale depth to the question. Retain recognized domain terms and explain their practical meaning. External analogies must not become project rules.

## Build the page

5. Read `references/page-design.md` relative to this skill for presentation and verification guidance. Choose visuals that explain this question: diagrams for relationships, timelines for processes, controls for changing assumptions, comparisons for alternatives, or illustrations for spatial concepts. Transitions and animation are available when they clarify a change; do not force every format into every page.
6. Save the default deliverable to `.dev/artifacts/domain-explanations/<topic>/index.html`. Use a short lowercase hyphenated topic and a unique suffix if it already exists. Update an existing page when the user requests a revision. Keep the page in the same artifact location across follow-ups. Use a tracked documentation destination only when requested; do not silently promote explanatory material into canonical project knowledge.
7. Prefer one self-contained HTML file with inline CSS, JavaScript, and SVG. It must open directly from disk without a build, network connection, or package installation. If additional local assets are useful, keep them alongside the HTML, use relative paths, and deliver the complete directory. Use available image-generation tools for bitmap illustrations when they materially help; inspect them and describe them as illustrations rather than evidence. A missing optional media tool must not block a useful page.
8. Write repository documentation in English unless the user explicitly requests another language. Include the original question, a clear answer near the top, explanatory sections, examples and boundaries, plus a compact sources section. Give source paths or URLs, the relevant claim they support, and short relevant excerpts or paraphrases so the page remains understandable offline. Link claims to source entries. Mark examples, assumptions, proposals, and unresolved questions where they appear. Include the generation date and repository revision when available; a page is a snapshot and does not track later changes automatically.
9. Make the explanation usable on desktop, mobile, with keyboard navigation, and in print. Use semantic HTML, legible contrast, visible focus, accessible names, and text equivalents for visual content. Keep the essential answer visible without JavaScript. Honor reduced motion. Interaction must reveal a relationship or test understanding, with assumptions and limits stated; it must not claim to simulate the real product unless that behavior is verified.

## Verify and deliver

10. Check content against the gathered sources. Check local assets and internal links. Ensure placeholders are removed, examples are labeled, and no unsupported domain rule or current-state claim has slipped into captions or interactive outputs.
11. Open the actual page in an available browser and inspect it at wide and narrow widths. Exercise each meaningful control, navigation, keyboard focus, and reduced-motion behavior. Check print presentation when supported. Fix observed layout or interaction defects and repeat affected checks. Follow the browser tool's supported API; if direct disk loading is unavailable, use a temporary loopback-only static server and stop it afterward. If browser access is unavailable, deliver the artifact and state that appearance and interactions remain unverified. Static checks do not establish browser behavior.
12. Open the saved result in the host's preview when available and return a clickable absolute HTML path with a short description of what the page teaches and what was actually verified. Include any local companion assets in delivery. Do not substitute a long chat essay for the requested artifact. Artifacts are ignored by Git; explain this when the user intends to commit, share, or retain them.

Creating a local explanation is within an explanation request. Publishing a site, installing system tools, updating Issues, or changing canonical definitions requires authorization for that action. Prepare the local page before any separately authorized publication; never publish merely to obtain a preview URL.
