---
name: verify
description: "Verify requested engineering behavior through the real runtime or artifact and report PASS, FAIL or BLOCKED with evidence."
---

# Verify

Answer whether the requested change actually works. Verification observes; do not fix application code or revise acceptance criteria during the verification pass.

Read the user request, relevant plan or spec, and the project verification recipe linked from its normal working map. Extract critical observable criteria; mark minimal inferred criteria explicitly. Match evidence to each criterion. Code inspection, compilation and passing unrelated tests do not establish runtime behavior.

Execute the existing recipe with real commands, fixtures and interfaces. Check that the tested process or artifact corresponds to the intended build and configuration, using available build identifiers, launch evidence or other direct evidence. Verify relevant UI, API, CLI, stored state, jobs or generated artifacts, and affected existing behavior. Choose checks proportionate to the change; a mechanical edit does not require a full system exercise.

When no recipe exists, discover actual project commands and execute the smallest reliable checks. Record a scoped candidate recipe containing startup and build identification, fixtures, behavior checks, expected results and cleanup only when reuse warrants it. Do not invent commands or silently create a new framework. Use temporary verification artifacts and clean up what you created.

Return per-criterion PASS, FAIL or BLOCKED with commands, observed results and evidence locations. Overall PASS requires evidence for every critical criterion; FAIL means demonstrated noncompliance; BLOCKED means critical verification cannot be completed. Preserve demonstrated failures even when another criterion is blocked. Distinguish uncertain coverage from incorrect behavior and provide the smallest actionable next step.

Send missing feedback, brittle fixtures, wrong-build risks, discovery failures and recipe gaps to [learn](../learn/SKILL.md). The implementer fixes failures and reruns affected checks. Harness improvements require their own original-failure and valid-case verification. Acceptance cannot be weakened to accommodate either application or harness defects.
