---
name: domain-explainer
description: 'Answer project domain questions with concise text and a diagram, or a separate black-theme HTML page for larger explanations. Use when a user asks how a domain concept, rule, relationship, or scenario works or requests a visual domain guide.'
---

# Explain the project domain

Answer the user's domain question with the smallest useful explanation. Keep both the explanation and the delivery message short. This skill allows implicit selection. Follow an explicit request for a format, language, or level of detail.

Use `domain-modeling` to establish or change a canonical definition. This skill explains current knowledge. It does not accept a proposal or update the glossary.

## Ground the answer

1. Read `AGENTS.md`, `docs/project.md`, and `docs/glossary.md`. Read relevant accepted decisions. Consult architecture, implementation, or a supplied Issue only when the answer needs them. In template mode, explain the template's domain. Do not invent a future product.
2. Identify the question and the reader's likely knowledge. Gather only the sources needed to answer it. Ask for missing information only when it changes the answer.
3. Separate accepted definitions, observed behavior, proposals, unknowns, and examples. If sources disagree, state the conflict. Preserve domain terms and explain their meaning. An analogy does not establish a project rule.

## Choose the output

4. Use **short text and a diagram** for a focused question that fits one definition, relationship, or small process. Put the answer first. Add a compact Mermaid diagram in chat when supported, or a local SVG when needed. Label the important relationships. Include a brief source reference. Do not create an HTML page for this route. If the user wants text only, omit the diagram.
5. Use a **separate HTML page** when the answer needs several linked concepts, branching cases, a worked scenario with multiple stages, or an animated or interactive explanation that does not fit one compact diagram. Make this judgment from the scope of the question, not a word-count calculation. An explicit request for HTML selects this route. A large page can have several sections, but each section must be concise.

## Write clearly

6. Aim to write about **80% of authored explanatory prose using ASD-STE100 principles**. Treat this as a style preference, not a measured compliance gate. Use short sentences, active voice, familiar words, and one main idea per sentence. Use the same term for the same concept. Remove filler, repeated conclusions, and decorative prose. Keep necessary domain terms, names, code, source quotes, and precise qualifications even when they need different wording.
7. Write repository documentation in English unless the user explicitly requests another language. Use the user's language for chat. ASD-STE100 is an English controlled-language standard with writing rules and a dictionary. For another language, apply the same clarity principles without claiming formal STE compliance. Do not claim certified or full compliance without the required vocabulary and rule review. Do not add a compliance calculation or checker to the normal workflow. See the [official overview](https://asd-ste100.org/about_STE.html).

## Build an HTML page when needed

8. Read `references/page-design.md` relative to this skill. Use a **black theme** by default. Diagrams, illustrations, transitions, animations, and interactive controls are available when they help explain the answer. Each visual should teach a relationship, change, or consequence.
9. Save the page to `.dev/artifacts/domain-explanations/<topic>/index.html`. Use a lowercase hyphenated topic and a unique suffix if it exists. Reuse the existing page for a requested revision. Use a tracked documentation destination only when requested.
10. Prefer a self-contained file with inline CSS, JavaScript, and SVG. It must need no build, installation, or network connection. Keep any companion assets beside it and use relative paths. Use available image-generation tools when bitmap illustrations help. A missing optional tool must not block delivery.
11. Put the question and direct answer near the top. Add only the sections needed to explain it, such as an example, process, comparison, or boundary. Label assumptions and illustrative scenarios. Include compact source references, generation date, and repository revision when available. The page is a snapshot, not a live source of project truth.
12. Design for desktop reading. Do not add mobile layouts, breakpoint variants, or mobile checks unless the user requests them. Use semantic HTML, readable contrast, visible keyboard focus, accessible control names, and text for important visual meaning. Keep the core explanation available without JavaScript. State the assumptions and limits of interactive examples. Do not present them as verified product behavior.

## Review and deliver

13. Review the content against its sources. Check local paths, diagram labels, HTML anchors, and interaction logic from the files. Remove placeholders and unsupported claims. Keep this review proportionate to the output.
14. **Do not run browser verification as part of this workflow.** Do not start a preview server or collect screenshots, viewport measurements, print previews, or browser interaction tests. If the user separately requests browser testing, perform it as that additional task. File review does not prove rendered appearance or runtime behavior.
15. Deliver the short answer and diagram in chat, or return a clickable absolute HTML path with one or two sentences about the page. Include companion assets when present. Do not repeat the page's content in chat. Report only material verification limits. Explain that artifacts are ignored by Git when the user intends to version or share them.

Local explanations are within the request. Publication, system-tool installation, Issue writes, and changes to canonical definitions require authorization for that action.
