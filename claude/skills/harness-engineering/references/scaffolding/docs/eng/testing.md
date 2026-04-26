# Testing

## Known commands

Record the repo's existing validation commands here.

- Unit tests:
- Integration tests:
- End-to-end or UI tests:
- Typecheck:
- Lint:
- Build:
- Local run command:

If a command does not exist or cannot run locally, say so clearly.

## What to validate

For each meaningful change, validate the behavior that changed. Prefer direct evidence: test output, build output, screenshots, logs, API responses, or a short manual reproduction transcript.

## UI changes

For UI work, record the route, state, user action, expected result, and any screenshot or browser evidence when available.

## Observability-sensitive changes

For logging, metrics, tracing, reliability, or performance work, record the signal that proves the behavior changed.

## Data or migration changes

For schema, migration, or data changes, record how the migration was tested, what can be safely rerun, and how partial failure should be handled.

## PR or completion evidence

When finishing work, summarize the validation that was actually run and the result. Do not claim a command passed if it was not run.
