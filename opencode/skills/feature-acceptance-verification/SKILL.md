---
name: feature-acceptance-verification
description: Use this skill when verifying whether a feature is actually complete against acceptance criteria, runtime behavior, tests, UI/API/CLI behavior, or a Ralph-loop completion gate.
compatibility: opencode
metadata:
  workflow: verification
---

# Feature Acceptance Verification

You are verifying feature completion, not reviewing code style.

Use this skill when:
- The task asks whether a feature is done.
- A Ralph-style loop needs a PASS/FAIL/BLOCKED completion gate.
- A feature must be checked against a PRD, ticket, user request, or acceptance criteria.
- UI, API, CLI, database, background-job, or integration behavior must be verified externally.
- Tests passed but user-visible behavior still needs validation.

Workflow:
1. Locate the source of truth: user prompt, PRD/spec, ticket, implementation plan, agent instructions, tests, or changed files.
2. Extract acceptance criteria.
3. If criteria are missing, infer minimal user-observable criteria and mark them as inferred.
4. Identify how each criterion can be verified externally: unit test, integration test, E2E/browser test, API request, CLI command, database/log inspection, build/typecheck/lint, screenshot, or visual check.
5. Run the smallest checks that provide strong evidence.
6. Mark every criterion PASS, FAIL, or BLOCKED.
7. Produce concise feedback that an implementation agent can act on.

Do not:
- Edit source files.
- Fix bugs.
- Approve based only on code inspection.
- Fail for unrelated style issues.
- Hide uncertainty.

Output:
- VERDICT: PASS | FAIL | BLOCKED
- CONFIDENCE
- Criteria table
- Evidence
- Gaps
- Ralph feedback
- Reviewer handoff
