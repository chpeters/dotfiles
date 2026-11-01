# Engineering skills

This is the owned engineering workflow in `agents/skills`. The skills are self-contained and automatically discoverable; no Compound Engineering or Pocock skill installation is required. Read the relevant contract rather than invoking every command for every task.

| Command | Responsibility |
| --- | --- |
| [`explore`](skills/explore/SKILL.md) | Trace real code behavior, history, ownership and architectural friction. |
| [`plan`](skills/plan/SKILL.md) | Resolve consequential decisions, prototype uncertainties and define verifiable behavioral slices. |
| [`build`](skills/build/SKILL.md) | Resolve requirements and design when needed, implement locally, fix findings and automatically verify the result. |
| [`review`](skills/review/SKILL.md) | Independently assess consequential correctness, integration risks and unnecessary complexity. |
| [`verify`](skills/verify/SKILL.md) | Execute real checks against the intended build; report criterion-level PASS, FAIL or BLOCKED. |
| [`ship`](skills/ship/SKILL.md) | Perform explicitly authorized commits, pushes, PRs or publication and inspect the resulting state. |
| [`learn`](skills/learn/SKILL.md) | Improve the harness from evidence, validate the intervention and connect it to future work. |
| [`teach`](skills/teach/SKILL.md) | Build the user's understanding through focused explanations, exercises and feedback. |
| [`cleanroom`](skills/cleanroom/SKILL.md) | Reassess a consequential decision with fresh neutral evidence. |
| [`readback`](skills/readback/SKILL.md) | Confirm intent, scope, constraints and completion criteria before action. |
| [`facts`](skills/facts/SKILL.md) | Explain important behavior, consequences, guarantees and unresolved risks. |

## The compounding loop

`build` calls `verify` and, for consequential changes, independent `review`. Findings return to implementation, followed by affected checks. Meaningful friction, corrections and reusable discoveries feed `learn`; routine work does not require a retrospective artifact.

`learn` distinguishes a product defect from a harness defect, diagnoses the cause, and chooses the smallest durable intervention. That may be a tool, fixture, executable check, verification recipe, navigation improvement, procedural correction or otherwise-lost reasoning. No change is a valid result.

An improvement earns confidence by catching the original failure and accepting a legitimate case. The normal project map must lead future agents to it, and an identified consumer must actually use it. Fresh-context testing checks discoverability where worthwhile; subsequent work establishes whether it remains effective. Prune ineffective or stale guidance. Writing a document alone does not establish compounding.

A project verification recipe contains actual commands, runtime/build identification, fixtures, observable checks, expected results and cleanup. Reuse the project's existing conventions; create artifacts only for demonstrated needs. Harness validation returns evidence to the existing learning pass instead of recursively starting another pass. Acceptance criteria cannot be weakened to obtain a pass.

## Boundaries

`build` stops locally. `ship` requires authorization for the requested publication; a PR request does not imply deployment or merge permission. `review` and `verify` assess rather than silently fix application code. `learn` can improve the authorized project harness, but does not autonomously rewrite this shared pack, global configuration or external systems.

Keep `AGENTS.md` a short map to authoritative guidance. Preserve decisions and evidence in an existing working plan when resumability warrants it. Personal teaching records belong in the user's chosen learning location, separate from product documentation.

## Synthesis and replaced skills

These are rewritten contracts combining the ideas discussed with the user, rather than wrappers that load upstream instructions:

- **Matt Pocock:** deep interfaces, locality, domain vocabulary, behavioral slices and tests, teaching, and retrospective environment repair.
- **Pstack:** caller-first design, runtime feedback, procedural cause diagnosis and learning continuity.
- **Compound Engineering:** integration scrutiny, consequential review, publication mechanics and preserving verified reasoning absent from final code.
- **Bro:** neutral independent judgment, request alignment and explanations of practical consequences.
- **Custom harness engineering:** minimal maps, existing conventions, real validation commands, source references and resumable work.
- **Custom acceptance verification:** observable criteria, evidence and explicit PASS/FAIL/BLOCKED outcomes.

| Removed or replaced legacy capability | New home |
| --- | --- |
| `codebase-design`, `improve-codebase-architecture` | `explore`, `plan`, `review` |
| `domain-modeling`, `grilling`, `grill-me`, `grill-with-docs` | `plan`, with domain context consumed across the workflow |
| `tdd` | Behavioral implementation and verification in `build` |
| Old `teach` | New `teach`, with Markdown and separate personal learning state |
| `handoff` | Resumability in `plan` and `build`; concise explanations in `facts` |
| `harness-engineering` | `learn`, with repository conventions consumed by the other skills |
| `feature-acceptance-verification` | `verify` |
| Compound Engineering workflow plugin | The owned commands above, without its runtime dependency |

## Validation scope

All eleven skill frontmatter files pass the skill creator's validator. UI metadata, local cross-links and updated agent/config syntax were checked. Those structural checks do not establish behavioral effectiveness. One isolated forward test exercised the learning and consumption loop. An existing verifier accepted a stale build while current application source was broken. A fresh agent using `learn` repaired the verifier, added executable valid-build, stale-build and fresh-invalid-build regression checks, and connected the procedure to the normal repository map without changing application source or acceptance criteria.

A separate fresh-context agent using `verify` followed that map, reran the regression checks and independently built the current source in a temporary copy. It correctly reported harness PASS and application readiness FAIL: the application still produced `HELLO Alice` instead of the required `HELLO ALICE`.

This establishes one observed intervention and subsequent discovery/consumption cycle. It does not establish that all eleven workflows have been exercised or that improvements remain effective across longitudinal real work.
