# User Decision Drift

Load this protocol only after code, tests, runtime evidence, review, or a proposed implementation conflicts with a user-confirmed product meaning, business rule, scope, flow, state, boundary, invariant, acceptance condition, or user-visible behavior. Ordinary implementation choices that preserve those decisions do not trigger it. Code may expose constraints, cost, and risk; it cannot change that authority.

## Resolution

1. Keep the affected path paused; independent work continues only when it cannot prejudge the decision.
2. Preserve the existing `Authority: user-confirmed` decision. State the confirmed mainline, `current implementation fact`, exact gap, constraint/cost/risk, and only materially different options.
3. Mark every alternative `proposed`. Ask one decision-bearing question; do not mutate the affected path until the answer is clear.
4. Record the answer faithfully: keep clear user wording verbatim; limit optional normalization to punctuation, obvious typo, grammar, or word order; label any Agent-derived summary as subordinate rather than letting it become the only normative record. Bind each short answer to its original question/options and preserve its force, actor/ownership, timing, uncertainty, boundary, negation/rejected direction, rationale, authority, scope, and `proposed | confirmed | superseded` status through [`define-requirement.md` § Decision Authority And Source Fidelity](../workflows/define-requirement.md#decision-authority-and-source-fidelity) in the governing Requirement mainline. If meaning changes, mark the prior decision `superseded`; never silently rewrite it.
5. Reconcile the affected Requirement Contract, Plan interface, Task Anchor, acceptance criteria, and implementation evidence before resuming. If the answer changes the mainline, re-project the Task Anchor, rebind implementation facts, and replace the remaining Native Plan before more mutation.

Never silently compromise a confirmed mainline to fit current code. If the proposed implementation must change the meaning, return to the user decision instead of resolving the conflict at implementation or Closure.

## Return

Return `resume` only when authority and every affected owner agree. Return `blocked` when the user decision is still missing. A late disclosure in review or Closure never substitutes for this gate.
