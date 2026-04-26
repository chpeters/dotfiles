# Agent guide

This repository uses lightweight harness engineering. Keep changes scoped, validated, and easy for another agent or human to resume.

## Start here

Before non-trivial work, read:

- `docs/architecture.md`
- `docs/quality.md`
- `docs/eng/testing.md`
- The relevant plan in `docs/plans/active/`, if one exists

## Plans

Use a plan document for multi-step, risky, or cross-cutting work. Create plans from `docs/plans/template.md` and store active plans in `docs/plans/active/`.

A plan should explain the goal, context, work sequence, validation, risks, progress, discoveries, decisions, and final outcome.

## Validation

Use the repository's existing test, lint, typecheck, build, or run commands. Do not invent scripts unless explicitly requested. If a command is missing or cannot run, record that clearly in the plan or final summary.

## Documentation

When architecture, quality expectations, testing approach, setup assumptions, or user-visible behavior changes, update the matching document under `docs/`.

## Boundaries

Do not add CI workflows, hooks, tools, MCP configuration, command rules, generated-doc systems, or new script suites unless explicitly requested.
