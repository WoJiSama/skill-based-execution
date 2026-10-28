# Change-Managed Workflow

Use this for non-bug changes whose partial edits can drift: features, refactors, generated/copied files, shared configuration, or changes with derived targets. A feature or any request that adds or changes user-visible behavior, a business flow/state, or an external contract is Managed even when it sounds local: complete Requirement Definition, let [`task-execution.md`](task-execution.md) project its Task Anchor, bind the implementation through Steps 1-3, and only after `implementation-ready` derive the Native Plan before mutation.

Start without preloaded knowledge; inspect the smallest source slice first. Before the first mutation, read [`change-discipline.md`](../rules/change-discipline.md).

For a requirement-bearing behavior/contract change, always evaluate [`change-contract.md`](../protocol-blocks/change-contract.md). A clear source Requirement or explicit request may satisfy `requirement-ready` with zero questions; otherwise enter [`define-requirement.md`](define-requirement.md) internally and return only the minimum normative question. Never ask the user to re-route. Once ready, establish the Task Anchor and consume [`source-localization.md`](../protocol-blocks/source-localization.md). Steps 1-3 must bind the returned owner, Current -> Target, affected path, high-cost boundaries, and proof obligations. Only then mark `implementation-ready`, derive the Native Plan from Steps 4-9, and permit mutation. For fixed-contract refactors or generated/copied changes, activate the contract only when desired outcome, authority, preservation, scope, or acceptance is not already fixed.

## Steps

1. **Replay the Requirement and bound the owner region** — carry its Goal, acceptance, material Boundaries, authority, and preserved behavior through the Task Anchor without rewriting them. Name candidate modules only as implementation hypotheses. If the change would alter user-confirmed desired behavior itself (type/flow/state/boundary/invariant), it returns to Requirement Definition.
2. **Find the source of truth and owner** — distinguish canonical content/state from generated, copied, or downstream consumers; trace provenance and the producer-to-consumer call chain.
3. **Map semantic fan-out** — name the invariant and list every affected full/incremental/read/write path, derived target, registration, test, and doc/index that must stay synchronized.
4. **Choose the technical design and owning boundary** — consume or produce the fitted Implementation Plan ([`plan-feature.md`](plan-feature.md) when a design choice is load-bearing). Default to Product Development and make every coordinated change needed for semantic completeness. Operational Stabilization requires an explicit production/availability/frozen-scope constraint and must expose unresolved structural work.
5. **Make the smallest semantically complete change** — use minimality only to choose among complete solutions; preserve unrelated edits and avoid adjacent cleanup.
6. **Sync derived files** with the owning generator/copy process.
7. **Check drift** across all mapped targets, semantic paths, and the user-confirmed mainline. If current or in-progress implementation diverges from desired meaning, invoke [`task-execution.md` § User Decision Drift Gate](task-execution.md#user-decision-drift-gate) immediately: pause the affected path, expose the gap/constraints/cost/risk, and obtain a user decision before continuing. If only a technical premise changes, rebind and revise the Plan. Do not silently fit the Requirement to existing code or wait until review/Closure.
8. **Validate behavior** with the cheapest sufficient fresh evidence; escalate only when concrete runtime/release risk requires it.
9. **Run [Task Closure](task-closure.md)** once after the integrated change.

## Completion Check

Scope, governing Requirement/mainline, applicable Plan technical decisions, any activated Change Contract, invariant, ownership/provenance, call chain, all semantic paths, fan-out targets, sync, resolved drift, targeted validation, and Task Closure are all accounted for without copying the complete shared protocols here.
