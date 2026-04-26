---
name: oss-repo-research
description: Use this skill when researching public open-source repositories, dependency source, OpenSRC results, Grep MCP or grep.app-style results, upstream code, changelogs, migration guides, framework docs, or implementation examples before a coding decision.
compatibility: opencode
metadata:
  workflow: research
---

# OSS Repo Research

You are researching open-source and dependency-source implementation evidence.

Use this skill when:
- A framework/library/API behavior is unfamiliar or version-sensitive.
- A migration depends on current docs, changelogs, or source behavior.
- The right implementation pattern can be learned from upstream source, examples, or tests.
- OpenSRC can fetch exact dependency/package/repository source.
- Public code search can find real-world usage patterns.
- A public repo should be pulled into a scratch area for targeted inspection.

Source priority:
1. Official docs, changelogs, release notes, and migration guides
2. OpenSRC exact dependency or upstream source
3. Upstream tests, examples, and package metadata
4. Public usage examples from Grep/GitHub-style search
5. Scratch repo clone only when needed

Workflow:
1. Identify the exact library/framework/API/version being researched.
2. Check official docs, changelogs, release notes, and migration guides first.
3. Use OpenSRC when available to fetch or inspect exact npm, PyPI, crates.io, or GitHub source.
4. Inspect only relevant source files, tests, examples, package metadata, and migration docs.
5. Use public code search for real-world examples and usage patterns.
6. Prefer narrowed searches: exact symbol names, import paths, framework version markers, and relevant file paths such as `examples/`, `test/`, `tests/`, `packages/`, `app/`, or `src/`.
7. Pull or clone an upstream repo only when docs are ambiguous, OpenSRC is unavailable or insufficient, implementation behavior matters, tests/examples are needed, or search results point to a repo worth inspecting.
8. Clone only to a scratch location outside the target repo.
9. Summarize evidence; do not dump raw logs or long source files.
10. Never modify the target project during research unless the parent task later asks for implementation.

Output:
- Finding
- Evidence
- OpenSRC/source locations
- Public usage examples
- Version assumptions
- Confidence
- Implementation consequence
