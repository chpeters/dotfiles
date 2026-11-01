---
name: plan
description: "Resolve engineering requirements and consequential design decisions into a scoped, verifiable implementation plan."
---

# Plan

Turn the request into observable behavior and a design the user can assess. Read existing conventions, vocabulary, decisions, and verification guidance before proposing another structure.

Separate unsettled decisions from implementation tasks. Look up facts yourself. Ask only questions whose answers materially change scope, behavior, or costly design choices; recommend an answer and explain the tradeoff. Work dependent decisions after their prerequisites. Preserve already authorized choices rather than repeatedly seeking approval.

Show the caller-facing interface and responsibilities. Compare materially different designs when the choice matters, judging depth, locality, ownership, and verification. Clarify overloaded domain terms against concrete edge cases. Record consequential, surprising tradeoffs in the existing decision convention only when future readers need the reasoning.

Use a small disposable prototype to settle uncertain behavior, ergonomics or feasibility when reading cannot settle it. State the question, evidence, result and disposal or adoption decision; do not silently promote prototype code.

Organize implementation into coherent behavioral slices with acceptance criteria, relevant integration risks, and verification evidence. For substantial or resumable work, update the existing plan convention with decisions, evidence, unresolved questions, and next actions. A tiny change needs no plan file or scaffold.

Finish with a usable plan and explicit remaining decisions. Planning does not authorize publishing or silently expanding scope. Route observed harness gaps to `learn`.
