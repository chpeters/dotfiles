---
name: explore
description: "Explain a codebase, trace behavior and history, or find architectural friction before deciding what to change."
---

# Explore

Build an evidence-backed explanation of the requested area. Follow one concrete operation from its real entry point through dependencies, state changes, outputs, and failure paths. Name who owns data, transactions, ordering, retries, and lifecycle where relevant. Distinguish observed behavior from inferred intent.

Read the repository's working map, relevant domain glossary, decisions, tests, and existing verification recipe. Follow pointers selectively. Use history to explain surprising choices; do not treat historical intent as current behavior. Inspect authoritative dependency documentation or source when framework behavior matters, using existing reference conventions without introducing application dependencies.

Identify complexity callers must understand, scattered knowledge, hidden coupling, and hard-to-exercise behavior. A useful module hides substantial behavior behind a small interface; assess that interface by everything callers must know, including errors, ordering and configuration. Do not propose abstractions merely to create test seams.

Return the concrete flow, important files, evidence, uncertainties, and the most useful next investigation. For architectural questions, explain how removing an abstraction redistributes complexity. Do not implement changes unless requested. Feed demonstrated navigation or context gaps to `learn`; ordinary exploration does not require new docs.
