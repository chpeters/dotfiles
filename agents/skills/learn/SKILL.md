---
name: learn
description: "Improve the engineering harness from observed work, validating durable fixes and ensuring subsequent runs discover and use them."
---

# Learn

Make future work measurably easier or more reliable. This is the feedback loop connecting all engineering skills, not a mandatory documentation exercise.

## Diagnose from evidence

Inspect actual outcomes, failed attempts, user corrections, successful techniques and gaps reported by `verify` or `review`. Separate application defects from harness defects. Determine whether the cause was missing capability, absent or undiscoverable context, confusing or conflicting guidance, ignored existing guidance, or inadequate feedback. Check existing tools and instructions before adding another rule. Distinguish verified causes from hypotheses.

## Choose the smallest durable intervention

- Repair an executable check, fixture, tool, feedback path or verification recipe when it directly addresses the cause.
- Improve navigation or procedures when the right capability exists but was not found or used.
- Preserve non-obvious verified reasoning only when code, tests and existing docs cannot convey it and losing it risks recurrence or substantial rediscovery.
- Update or remove an existing artifact rather than duplicating it. No change is a valid outcome when evidence does not justify one.

Use the repository's existing conventions. Keep `AGENTS.md` a short map pointing to authoritative material. Create documents lazily for demonstrated needs, without scaffolding empty directories or a parallel documentation system. For resumability, preserve task-specific decisions and evidence in its working plan. Keep dependency reference sources separate from application dependencies.

## Close the loop

For each intervention, state the original failure, intended improvement and scope. Within authorized scope, implement and validate it against the original failure and a legitimate passing case. Run scripts and recipes rather than only proofreading instructions. Verification of this intervention returns evidence to this learning pass; do not recursively start another automatic learning pass. Never weaken product acceptance criteria to manufacture a pass.

Ensure future consumers discover and use the improvement: update the relevant map or entry point, and identify which skill or check consumes it. When worthwhile and delegation is available and authorized, test a fresh agent with only the normal entry point and raw task artifacts, without telling it the expected conclusion. Otherwise disclose that fresh-context consumption remains unverified.

Record enough evidence for later work to assess effectiveness. On subsequent use, inspect whether the intervention caught the mistake or reduced friction. Prune ineffective, stale, duplicated or overly specific guidance; do not equate growing documentation with compounding.

## Mutation boundary and result

A request to `learn` authorizes scoped harness improvement in the named project, subject to existing permissions. It does not authorize changing global configuration, shared skills, external systems, or user preferences beyond that scope. Propose an exact broader change and obtain authorization when required. Do not autonomously rewrite this skill pack from one session's experience. Follow the user's designated durable-memory system and its write rules.

Return the evidence and diagnosis, intervention or no-change rationale, validation outcome, future discovery/consumption path, and remaining uncertainty. Distinguish implemented, validated and later-observed effectiveness.
