# Receiving Code Review Workflow

Use this when acting on user, reviewer, PR/MR, or agent review feedback. Evaluating a critique and deciding to accept or push back is main-agent judgment; only an admitted mechanical recheck may use a subagent.

## Process

1. Read the whole review before acting on any item. For Design-derived work, replay the governing user decisions and the source Plan's relevant technical choices before accepting a change.
2. Restate each technical claim; clarify genuinely ambiguous feedback before editing.
3. Verify every claim against current code, behavior, and constraints. Reviewers can be wrong or stale.
4. Check whether the suggested change is warranted: inspect real usage and reject speculative "proper" implementations.
5. For accepted items, implement the smallest correction. For rejected items, state concrete evidence without defensiveness or performative agreement.
6. Re-run fresh targeted evidence, then [Task Closure](task-closure.md) if behavior changed.

Push back when feedback breaks a real case, misses a binding constraint, has no actual usage, or conflicts with an explicit user decision. If accepting feedback would change the confirmed mainline, invoke [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate): pause the affected path and ask the user immediately.

## Completion Check

- Whole review was read first.
- Every accepted/rejected item has code or runtime evidence.
- Relevant decisions and Plan technical choices were replayed; review-driven normative drift has an explicit user resolution.
- No praise/apology substituted for verification.
- Accepted changes were re-verified; rejected changes have concise evidence.
