# Change Contract Protocol

Use this after workflow selection when work adds or changes user-visible
behavior, a business flow/state, or an external contract, or when missing
meaning could change scope, preservation, permission, or acceptance. This file
is the sole semantic owner of the runtime Requirement Contract and its later
Implementation Binding. It is not a task route, question script, source-search
procedure, Task Anchor, Native Plan, or persistent artifact.

## Activation And State

- Evaluate the Requirement Contract before implementation planning or mutation.
  A clear request, confirmed Requirement/issue/PRD, or accepted decision may
  satisfy it immediately without expanded state or another confirmation. Apparent
  locality, estimate, elapsed time, file count, keywords, or complexity never
  bypasses or proves readiness.
- Keep one evolving runtime contract:
  `requirement-incomplete -> requirement-ready -> localization-required/owner-proven -> binding-incomplete -> implementation-ready`.
  Return to Requirement Definition when evidence reopens desired meaning; return
  to localization when technical ownership or Current behavior changes.

## Requirement Contract

Record only dimensions whose answer can change the result:

- desired goal and observable user/business outcome;
- scope, non-goals, preserved behavior, and permission boundary;
- decision-bearing actor/trigger, model/object relationship, concrete flow,
  state, ordering, and interaction;
- rules, defaults, constraints, failure meaning, and compatibility behavior;
- observable, falsifiable acceptance that can reject a wrong result;
- authority, confirmed facts, assumptions, real risks/conflicts, and remaining
  normative choices.

A technical option belongs to the Requirement only when it is itself a
user-owned product/architecture constraint that changes desired behavior,
scope, or acceptance. Ordinary implementation choices belong to the Plan.
Every material requirement-bearing input receives an evidenced disposition;
inference may generate candidates but cannot create authority or associatively
expand behavior. These dimensions are conditional, never a fixed questionnaire.

`requirement-ready` means no remaining user-owned choice can redirect any
activated goal, scope, model/flow, rule/constraint, permission, preservation, or
acceptance. Agent-discoverable files, symbols, callers, state/config owners,
paths, Current behavior, feasibility, cost, and risk remain technical unknowns;
send them to [`source-localization.md`](source-localization.md), not the user.
Use [`define-requirement.md`](../workflows/define-requirement.md) and one minimum
question through [`ambiguous-request-gate.md`](ambiguous-request-gate.md) only
for a remaining normative blocker.

Code, tests, and runtime evidence may prove Current behavior, constraints, cost,
or contradiction, but cannot choose desired meaning. The Requirement owns
acceptance; a red test, automated suite, browser/runtime readback, or human
review is only a later Plan-selected way to prove it. An unstated expected
result exposed while designing a test returns to Requirement Definition.

## Implementation Binding

- After Task Execution projects the ready Requirement into Goal, Done When, and
  material Boundaries, give source localization that desired contract, candidate
  region/vocabulary, technical unknowns, and falsification evidence. Consume its
  proven canonical owner, Current behavior, change point, affected path,
  contradictions, and residual uncertainty.
- Bind Current -> Target without changing the Requirement. `implementation-ready` requires the still-valid Requirement Contract, proven owner/source relation,
  decision-bearing Current -> Target path, affected technical boundary, and
  closed high-cost contract/permission/data/transaction/compatibility/migration/
  failure risks. It also names proof obligations and available seams without
  selecting detailed test commands or inventing acceptance.
- A final file list, line-level design, exhaustive call graph, helper names, and
  written tests are not prerequisites. Admit later files only through a proven
  producer/consumer/state/contract/generation edge and update impact/proof.
- Evidence changing desired meaning or acceptance returns to Requirement
  Definition; evidence changing owner or a high-cost implementation boundary
  returns to localization. A conflict with user-confirmed meaning invokes
  [`task-execution.md` § User Decision Drift Gate](../workflows/task-execution.md#user-decision-drift-gate).

## Consumers And Lifetime

Task workflows repeat only local trigger/input/output/acceptance. Task Execution
creates the Task Anchor after `requirement-ready`, but creates the Native Plan
only after `implementation-ready`; the Plan consumes rather than defines the
Requirement. Closure reconciles final behavior and proof against the same
Requirement projection. Keep this contract in current Session state by default;
ordinary tasks create no contract file, ledger, Wiki, manifest, index, database,
or generated state.
