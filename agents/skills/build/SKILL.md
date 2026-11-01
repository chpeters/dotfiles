---
name: build
description: "Build an engineering feature or change locally, resolving requirements and design when needed, then implementing, reviewing and verifying the result."
---

# Build

Deliver the requested behavior locally. Read the repository map and relevant linked guidance, plan, decisions, and project verification recipe. Inspect the dirty tree and preserve unrelated work.

For a concrete request or settled plan, proceed directly to implementation. When missing codebase context prevents a sound design, apply [explore](../explore/SKILL.md) to the relevant behavior. When requirements, acceptance criteria or consequential design choices remain unresolved, apply [plan](../plan/SKILL.md) before dependent implementation. Resolve facts from the repository and ask only for decisions that materially affect the outcome. Reuse settled decisions and existing plans; do not require a plan document for small changes. Once the necessary decisions are resolved, continue into implementation in the same task rather than stopping at a plan or requesting routine approval. Respect any explicit user checkpoint or planning-only scope.

Work in coherent behavioral slices. Discover existing tests first. Use a meaningful failing test or characterization baseline when practical; observe the intended failure before implementing. Exercise public behavior rather than internal collaboration, and avoid redundant tests or production hooks added solely for tests. Tiny mechanical or manual-only changes can use proportionate replacement evidence.

Keep responsibility behind small useful interfaces, follow domain vocabulary, update affected callers, and remove superseded local implementations. Trace integration effects beyond changed files, including callbacks, middleware, persisted state and other interfaces. Add mechanisms only when requested or required by a demonstrated contract or failure.

After repeated unsuccessful fixes, investigate the shared assumption instead of accumulating patches. Simplify settled code without reopening user decisions.

Before completion, automatically apply [verify](../verify/SKILL.md) to the resulting change. For consequential changes, also obtain independent [review](../review/SKILL.md) when delegation is available and authorized. Otherwise perform an explicit review pass and disclose that independence was unavailable. Fix valid findings, then rerun affected verification; stale evidence cannot establish completion after relevant edits. Do not require elaborate review ceremony for trivial changes.

When meaningful friction, corrections, reusable discoveries or verification gaps arise, invoke [learn](../learn/SKILL.md) to assess them. It may legitimately produce no harness change; trivial work does not require a retrospective. Carry scoped, authorized improvements through validation; propose broader changes rather than silently rewriting shared skills.

Report behavior delivered, verification evidence, review resolution, and residual blockers. Stop locally. Commit, push, PR creation, deployment and external publication belong to explicitly authorized `ship` work.
