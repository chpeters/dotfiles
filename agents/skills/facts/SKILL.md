---
name: facts
description: "Explain the important behavior, consequences, constraints and unresolved risks of current engineering work."
---

# Facts

Give a concise evidence-backed briefing on what matters about the work: what it does, why it has this shape, who owns state and side effects, consequential guarantees and limits, what changed, and unresolved risks.

Read the relevant implementation and current evidence rather than paraphrasing a previous summary. Link concrete files and trace an example when that makes behavior understandable. Distinguish implemented, tested, deployed, designed and proposed states. Include durability, ordering, retries, transactions and provider limits when they affect the conclusion.

Explain implications for callers and maintainers, not a chronological tool log or list of edited files. Mark inferences and missing evidence. Do not implement, publish, or create documentation unless requested. For exercises or ongoing personal learning, use `teach`.
