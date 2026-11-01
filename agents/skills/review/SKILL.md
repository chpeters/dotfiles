---
name: review
description: "Assess an engineering diff or design for correctness, regressions, hidden dependencies and unnecessary complexity."
---

# Review

Judge the artifact against the user's requirements and actual repository contracts. Read enough surrounding code to trace affected callers, lifecycle, persistence and failure paths. Review evidence independently when available; do not inherit the implementer's conclusion as a premise.

For a standalone review of consequential work, use a fresh reviewer when delegation is available and authorized, supplying requirements and raw artifacts without the prior verdict. If you are already that fresh reviewer, perform the review directly without delegating again. When fresh context is unavailable, disclose the same-context fallback. Trivial changes need no separate reviewer.

Prioritize actionable defects: incorrect behavior, regressions, missing critical coverage, unsafe state transitions, integration failures, or avoidable complexity that materially harms understanding. Check whether interfaces hide complexity or merely move it onto callers. Respect settled design decisions while reporting defects within them.

Substantiate each finding with a concrete trigger, consequence, and exact location. Distinguish confirmed defects from unresolved questions. Do not manufacture findings or demand abstractions and tests that mirror implementation.

Review does not replace runtime `verify`. Return findings by severity, remaining uncertainty, and whether consequential risks are resolved. Apply fixes only when requested; the implementer must reverify affected behavior. Feed demonstrated review-process gaps to `learn`.
