# Task Closure Protocol

This is the completion-time gate between finished local execution and verified delivery for behavior, rule, routing, script, and structure changes. It owns readiness and completion states. SBE is stateless: lessons found here are reported to the user in the final message, never written into the target project; only changes to SBE's own repository become durable, through a normal Managed change.

## Entry Gate

Closure starts only after local execution is complete. For a Simple task, the direct check and all non-delivery goal evidence must exist. For a Managed or Design-derived task, first run the final Anchor Checkpoint; every non-delivery Native Plan step must have passed its check, material Boundaries must remain intact, and no stale Plan branch may remain. Any outstanding Done When evidence must be explicitly delivery-dependent, with the expected artifact and proof named before Closure advances.

If implementation work or non-delivery evidence is missing, return to [`task-execution.md`](task-execution.md); do not use Closure to finish execution work. A Plan status or worker claim is not evidence by itself.

## Trigger Policy

| Task | Required closure |
|---|---|
| Pure Q&A/read-only advice with no file change | none |
| Formatting/comment/behavior-preserving rename with no reusable lesson | relevant text check only |
| Production behavior, API/schema, validation, state, transaction, async, or call-chain change | fresh verification + lightweight AAR |
| Rule/workflow meaning change inside SBE itself | AAR + conformance check |
| Routing, SKILL.md, script, or structure change inside SBE itself | full structure closure: `scripts/smoke-test.sh` + `scripts/check-conformance.sh` |
| User explicitly requests full validation | run the requested suite |

## Closure Steps

1. **Read back the contract** — restate the governing Requirement projection and Task Anchor (or Simple-task outcome): matched route, Goal-level acceptance evidence, material Boundaries, Plan-selected proof set, escalation signals, stop point, and forbidden shortcuts. Closure consumes that contract; it does not redefine Requirement meaning, localization stages, read breadth, or proof depth after green. After a long/interrupted task, use [`reboot-check.md`](../protocol-blocks/reboot-check.md).
2. **Verify with fresh, fitted evidence**:
   - bind each material risk to the cheapest evidence that can falsify it and state the stop/escalation condition before running checks;
   - targeted command/test/typecheck first;
   - runtime/service/browser evidence only for wiring, config, permissions, serialization, data state, or UI behavior;
   - packaged/release/deploy evidence only when that chain changed or the user requires it.

   Stop when the bound evidence proves the contract; escalate only when a check fails, the risk crosses another boundary, or a stated uncertainty remains. Test count is not evidence quality. A fresh command against a stale artifact is not fresh evidence. For a defect repair, report the recorded red reproduction → same-case green proof; historical red evidence remains valid and is not a reason to rewind or rerun the broken version.
3. **Account for failures** — enumerate every command, test, runtime, delivery, or premise failure whose root cause was proven during the task, with its repair and proof. Report them in the final message; write no record into the target project.
4. **Run the AAR below.** A yes is reported to the user with a concrete destination suggestion (the project's own skill, when one owns the task domain); SBE records nothing on its own initiative.
5. **Run conditional integrity work (SBE's own files only)** — a change to this skill's routing, SKILL.md, workflows, rules, or scripts must also pass `scripts/smoke-test.sh` (structure, budgets, routing↔SKILL sync, links) and `scripts/check-conformance.sh` (behavior anchors) before readiness.
6. **Declare readiness** — only after Steps 1–5 pass, name any already-authorized delivery action, expected artifact, and exact verification. `Ready for Delivery` is a checkpoint, not task completion.

### Delivery and Completion Gate

Closure never grants commit, push, MR, deploy, publish, or other side-effect authority. The matched workflow or harness performs only the delivery already authorized by the user, while Closure remains open.

- When the user requested an external/shared-system artifact, read [`external-delivery-verification.md`](../protocol-blocks/external-delivery-verification.md) and consume its `verified / blocked / stale / premise-changed` result. The protocol verifies the artifact but cannot grant authority or declare completion.
- When no external delivery was requested, the verified local result and final response are the delivery artifact.
- Task Closure alone marks `Closure Complete`, and only after every required local and conditional proof has passed and every requested artifact is verified. Name residual risk without self-certifying beyond the checks run.

### Rationalizations to Reject

| Rationalization | Reality |
|---|---|
| “The change is small.” | Behavior/structure is the trigger; read-only work is already exempt. |
| “Tests passed earlier.” | A completion claim requires fresh evidence after the final edit. |
| “I'll report the lesson later.” | The decision context will be gone; report it in the same final message. |
| “The file exists and smoke is green.” | Reachable structure can still be inert; state the next action it changes. |
| “The command exited 0, so the stage is complete.” | A successful exit code proves only the command's own contract. If it does not resolve the step's question, validate target behavior, or produce evidence consumed by the next step, return to Task Execution. |
| “I should record this lesson for the project.” | SBE is stateless; durable project knowledge belongs to the project's own skill, decided by its owner — never written by SBE. |

### Red Flags

- claiming “done/should pass” without reading a fresh exit code, or treating that exit code as sufficient completion evidence by itself;
- claiming completion from `Ready for Delivery` or from an unverified precursor such as a pushed branch;
- writing gotchas, references, rules, ledgers, or any record into the target project;
- treating optional delegation or future infrastructure as a completion requirement.

## After-Action Review

Ask only after Trigger Policy admits the task:

1. Did this reveal a repeatable costly pattern not obvious from code?
2. Did a missing rule or activation path cause a wrong turn?
3. Did an external fact materially affect the decision and need scoped re-verification guidance?

Any yes → report the lesson to the user with a suggested durable destination: the target project's own skill (if it owns the domain), or — for a lesson about execution discipline itself — a Managed change to this repository. Otherwise create no record and stop.
