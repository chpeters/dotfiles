---
name: ship
description: "Commit, push, create or update a pull request, or perform explicitly authorized publication after verification."
---

# Ship

Publish only the actions and destinations authorized by the user. Resolve the actual repository, branch, remote and dirty tree before acting. Preserve unrelated changes; stage explicit paths and inspect the staged diff. Do not infer deployment or merge authority from a request to open a PR.

Require current verification evidence for the artifact being shipped. Run relevant checks when evidence is absent or changes invalidate it; report missing critical verification rather than claiming success. Address consequential review findings before publication.

Use repository commit conventions and cohesive commit boundaries. Write multiline messages and PR descriptions as files or structured arguments so shell interpretation cannot corrupt them. Explain the concrete resulting behavior and validation in PR descriptions; follow existing templates where useful.

Verify each requested external outcome from its resulting state: pushed ref, created PR, CI result, deployment or published artifact. Attach created or worked-on PRs using the app's artifact tool when available. A successful command alone is insufficient when the resulting state can be inspected.

Stop after the requested publication. Ongoing monitoring, merge or deployment requires corresponding authorization. Report links, verification, and any outstanding checks. Route demonstrated publication-process failures to `learn`.
