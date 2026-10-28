# Fix Bug Workflow

Use this route to determine whether observed behavior is an implementation defect and, if so, prove a semantically complete repair. For a non-Simple task, [`task-execution.md`](task-execution.md) turns these steps into the current Task Anchor and Native Plan without weakening the gates below. An independent investigation may run in a subagent when the harness offers one; synthesis stays with the main agent, and its output is candidate evidence.

## Mandatory Pre-Step

Re-match the task route. Do not patch before expected behavior and the actual root cause are established; inspect the smallest reproduction/source slice first.

Reuse a clear observed/expected contract as the fast path. When expected behavior, authority, preserved behavior, scope, or acceptance is still material, use [`change-contract.md`](../protocol-blocks/change-contract.md); when only the technical entry/owner/change point is unresolved, consume [`source-localization.md`](../protocol-blocks/source-localization.md). The resulting bound contract must identify the repair target and root-cause path before mutation.

**Design-or-defect gate:** when behavior depends on product semantics, compare user-confirmed desired behavior, architecture/contracts, and code/tests/runtime. Classify:

- `IMPLEMENTATION_BUG` — implementation violates the confirmed desired behavior or contract;
- `DESIGN_CHANGE` — the requested result changes a type, flow direction, state machine, core invariant, or stable boundary of desired behavior;
- `INSUFFICIENT_CONTEXT` — evidence cannot establish intended behavior.

A Design Change leaves this workflow for [`plan-feature.md`](plan-feature.md). For insufficient context, search evidence first and cross-check it against any existing user-confirmed answer. Execute [`ambiguous-request-gate.md` § Implementation-Fact Question Gate](../protocol-blocks/ambiguous-request-gate.md#implementation-fact-question-gate): close every decision-relevant trigger/entry, caller, write target or target branch/state, ordering/progression, guard/protection/validation/failure, and UI/API ownership hop; trace distinct flows independently. If evidence and confirmed answers align, continue without another question. Otherwise enter [`define-requirement.md`](define-requirement.md), present the current understanding and real conflict, and ask only a remaining normative ambiguity that could change repair classification or expected behavior. Never ask the user to choose a Current implementation fact, request exhaustive detail, or define an abstract concept from scratch. If the user says the answer is in code, stop asking and finish the trace first. Obvious technical failures need no product-model debate.

Replay the relevant user-confirmed decisions before defining expected behavior or changing code. Code/tests/runtime are `current implementation fact`, not authority to rewrite `desired behavior`. If the proposed or in-progress fix would drift from the confirmed mainline, invoke [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate) immediately; pause the affected path and consult the user instead of smuggling the change through Bug Fix or reporting it only at Closure. User statements of expected behavior are consumed into the Requirement Contract for this Session; SBE writes no record into the target project.

## Steps

1. Restate the observed behavior, affected scope, and expected result. Before the first mutation, read [`change-discipline.md`](../rules/change-discipline.md).
2. Classify with the Design-or-defect gate.
3. Reproduce the defect with a failing automated check for the reported reason; if automation is impossible, give repeatable manual steps and why.
4. Trace the real root cause. Identify the violated invariant, state ownership/provenance, producer-to-consumer call chain, and every affected full/incremental/read/write path.
5. Apply the **Repair-depth gate** — default to Product Development and repair the invariant-owning boundary, including coordinated multi-layer changes when required. Use Operational Stabilization only for an explicit production/availability/frozen-scope constraint; containment must be reversible and leave the structural repair visibly unresolved.
6. Implement the smallest semantically complete repair; dependency count increases validation duty but cannot veto the correct boundary. Avoid unrelated cleanup.
7. Inspect direct and indirect consumers plus changed contracts, data compatibility, shared state/config, events, and async ordering. Resolve any unknown that could invalidate the fix.
8. Run the same acceptance check to green and the smallest relevant regression across every affected path. Escalate to runtime/release evidence only when the changed behavior requires it.
9. Run the [Task Closure Protocol](task-closure.md).

After three failed approaches, stop and report the attempts and false premise instead of trying a fourth variant.

## Completion Check

- Classification and design basis are explicit.
- The failing check reproduced the real defect before code changed and passes afterward.
- Invariant ownership, call chain, all affected paths, direct/indirect impact, compatibility, and residual uncertainty were inspected.
- Product Development vs Operational Stabilization was selected from task evidence, not implementation convenience.
- No type/flow/state/invariant change was smuggled through Bug Fix.
- Relevant user decisions were replayed, and any normative drift was resolved with the user before continuing.
- Any missing product question was grounded in a concrete flow and an evidence-backed working conclusion before the user was asked to compare or correct it.
- The decision-relevant implementation path was closed; distinct flows were traced independently and no interface, write target, branch protection, call order, or state progression was presented as a user choice.
- Task Closure ran once after the integrated fix, and any proven lesson was reported, not persisted into the target project.

## Final Report

Report classification/design basis, root cause, change, red→green verification, blast radius, and uncovered risk. Do not narrate the whole diff.
