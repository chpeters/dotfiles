---
name: harness-engineering
description: "Use this skill when asked to add or maintain lightweight harness engineering in a repository: AGENTS.md, minimal repo docs, plan documents, testing guidance, quality notes, agent-readiness, execution plans, validation workflows, and cleanup loops. Do not use it for unrelated coding tasks unless the task explicitly asks to improve repo guidance or agent workflows."
---

# Harness Engineering

Use this skill to make a repository easier for coding agents and humans to understand, modify, validate, and resume. Keep the harness lightweight: prefer a few durable files over a framework.

The intended result is a repo where:

- `AGENTS.md` gives a short working map.
- Plan documents preserve context for multi-step or resumable work.
- Docs explain architecture, quality expectations, and validation at a high level.
- Agents can find important context without relying on chat history.
- Repeated mistakes turn into a small doc, test, script, or process improvement.

## Boundaries

Do not add hooks, command rules, MCP configuration, generated-doc systems, CI workflows, tool suites, or populated scripts unless the user explicitly asks for them.

Do not create both `.agent/` and `.agents/`; use `.agents/skills/harness-engineering/SKILL.md` for this skill.

Do not invent validation commands. Prefer the repository's existing test, lint, typecheck, build, and run conventions.

## Default Shape

For a repo that has no harness yet, the minimal target shape is:

```text
.
├── AGENTS.md
├── docs/
│   ├── architecture.md
│   ├── quality.md
│   ├── eng/
│   │   └── testing.md
│   └── plans/
│       ├── template.md
│       ├── active/
│       ├── completed/
│       └── abandoned/
├── scripts/
│   └── README.md
└── .agents/
    └── skills/
        └── harness-engineering/
            └── SKILL.md
```

Use `docs/architecture.md`, not `docs/architecture.md.md`.

## Workflow

1. Inspect the repository structure and existing docs.
2. Check whether `AGENTS.md`, `docs/architecture.md`, `docs/quality.md`, `docs/eng/testing.md`, and `docs/plans/template.md` already exist.
3. Preserve existing conventions when they are clear.
4. Add only missing minimal files, using the scaffold references when helpful.
5. Keep content brief, practical, and repo-specific where possible.
6. For real feature, bug, migration, or refactor work that is complex or risky, create or update a plan under `docs/plans/active/`.
7. Record validation honestly. If a command is missing or cannot run, say so in the plan or final summary.
8. At the end, summarize what was added, what was intentionally skipped, and any future harness improvements worth considering.

## Reference Scaffolds

Load only the specific scaffold you need:

- `references/scaffolding/AGENTS.md` - starter repo working guide.
- `references/scaffolding/docs/architecture.md` - short architecture doc template.
- `references/scaffolding/docs/quality.md` - compact quality expectations template.
- `references/scaffolding/docs/eng/testing.md` - validation and testing guidance template.
- `references/scaffolding/docs/plans/template.md` - resumable plan template.
- `references/scaffolding/docs/plans/active/README.md` - placeholder for active plans.
- `references/scaffolding/docs/plans/completed/README.md` - placeholder for completed plans.
- `references/scaffolding/docs/plans/abandoned/README.md` - placeholder for abandoned plans.
- `references/scaffolding/scripts/README.md` - placeholder for intentionally empty script directories.

When installing this skill into another repo, copy this `SKILL.md` and the `references/` directory together to `.agents/skills/harness-engineering/`.

## Cleanup Loop

When an agent gets stuck, makes a bad assumption, produces an unreviewable diff, misses validation, or needs context from a human, treat it as a possible missing harness component.

Choose the smallest durable fix:

- `AGENTS.md` for repo-wide working instructions.
- `docs/architecture.md` for structural understanding.
- `docs/quality.md` for recurring quality expectations.
- `docs/eng/testing.md` for validation guidance.
- A plan document for task-specific context, decisions, progress, and outcome.
- A test or tiny script only when documentation is not enough.

Mention hooks, command rules, CI workflows, MCP servers, generated docs, architecture linting, dependency checks, richer security docs, or repo-specific scripts only as future enhancements when repeated failures justify them.
