# Requirement Definition Workflow

Use this workflow when the requested deliverable is to understand, discuss, brainstorm, correct, or confirm desired behavior before implementation planning. Ordinary feature and behavior-change workflows may enter it internally when their requirement is incomplete; the user never has to re-route or restate the request. This workflow produces `requirement-ready` and, only under its own Artifact Pressure Gate, a durable Requirement artifact in the target project's own convention. It never produces an implementation Plan, Task Breakdown, code mutation, or proof command.

[`change-contract.md`](../protocol-blocks/change-contract.md) is the sole owner of Requirement Contract dimensions, authority, readiness, and return states. This workflow owns only the evidence and interaction needed to complete that contract.

## Intake And Evidence

1. Preserve the user's clear wording as the normative source. Consume an existing issue, PRD, or accepted decision directly when it already has authority; do not manufacture a duplicate document or confirmation turn.
2. Evaluate only the Requirement Contract dimensions activated by this request. Do not turn goal, scope, model/flow, rules, constraints, and acceptance into a fixed questionnaire or require irrelevant fields.
3. Inspect the smallest code, documentation, configuration, test, runtime, or prior-decision evidence that can resolve the current uncertainty. Use [`source-localization.md`](../protocol-blocks/source-localization.md) for an Agent-discoverable owner, path, symbol, Current behavior, feasibility, cost, or risk. Code may constrain or falsify a premise; it cannot choose desired product meaning for the user.
4. Separate confirmed normative input, current implementation facts, Agent assumptions, real risks/conflicts, and unresolved choices. Inference may generate candidates but never creates requirement authority.

## Readiness Paths

### Clear Requirement

When explicit input already closes every activated user-owned choice, record the source-faithful Requirement Contract and return `requirement-ready` immediately. Do not require the user to reply with a ceremonial confirmation. Keep it Session-only unless the Artifact Pressure Gate below admits a durable artifact. Do not create a Task Anchor or implementation Plan here.

### Incomplete Requirement

When a remaining normative choice could change the goal, scope, preserved behavior, model or flow, rule or constraint, permission, or acceptance:

1. present the current understanding in concrete outcome terms;
2. name only evidence-backed risk, conflict, or materially different meaning;
3. ask the minimum normative question needed to choose among those meanings;
4. stop before implementation planning, Task Breakdown, or mutation.

Do not ask the user for repository facts the Agent can discover. Do not fill a gap with an "implementation assumption". After the answer, update the same Requirement Contract and repeat only the still-open readiness check.

## Brainstorm Boundary

Requirement brainstorming explores outcomes, actors, models, flows, states, ordering, interactions, rules, constraints, failure meaning, compatibility, and observable acceptance. Keep alternatives only when they represent genuinely different desired contracts. A technical option belongs here only when the user is choosing a product or architecture constraint that changes behavior, scope, or acceptance.

Discuss one load-bearing normative topic at a time. For a genuinely unresolved topic, present the current understanding, decisive factual evidence and constraints, material risk or trade-off, the Agent's recommendation, and at most one minimum normative question. Make the content detailed enough for the decision; do not replace it with a three-line summary or batch confirmation list. When the Requirement is already clear, ask no question and manufacture no alternative.

Class names, storage layout, framework choice, task ordering, test framework, and other ordinary implementation means belong to [`plan-feature.md`](plan-feature.md) after `implementation-ready`. If a technical investigation exposes a normative conflict, return here instead of bending the Requirement to the current code.

## Decision Authority And Source Fidelity

Capture a compact Requirement Decision Delta only when the user selects, rejects, corrects, or defines load-bearing meaning: trigger/question -> faithful answer -> `Authority: user-confirmed` -> normative meaning and scope -> Agent-derived consequences -> affected requirement and acceptance. Replacements become `superseded`; they never silently rewrite the mainline.

Keep a clear user statement verbatim as `User source`. If readability truly requires normalization, change only punctuation, obvious typos, grammar, or word order and keep the original adjacent. Never omit or merge a command, question, refusal, actor, ownership, timing, uncertainty, emphasis, boundary, reason, or rejected direction. Label any interpretation as Agent-derived and subordinate.

## Requirement Artifact Pressure Gate

Keep the Requirement Contract in the current Session by default. Create a durable artifact only when the user explicitly asks for a Requirement/PRD artifact, or when an independent reader, review, recovery, validator, lifecycle, or handoff must consume the desired contract. Complexity, activity, implementation size, or a clear Requirement alone is not pressure.

Reuse an authoritative existing issue, PRD, or accepted decision instead of duplicating it. A durable artifact follows the target project's own docs convention; if the project has none or the destination is unresolved, stop the write and stay Session-only rather than inventing a taxonomy for someone else's project. Create only the natural single file that the proven reader needs.

The artifact owns source/authority, desired goal, scope and preservation, decision-bearing model/flow, rules and constraints, observable acceptance, and confirmed or superseded normative decisions. Label supporting Current facts as implementation evidence. Exclude Current -> Target implementation design, Task Breakdown, task ordering, proof commands, and live step status. Writing the Requirement does not enter Plan Feature or authorize mutation.

A later durable implementation Plan links to and consumes this owner one way. Plan Feature cannot copy, narrow, resolve, or update it. A normative change returns here, updates the Requirement through its authority, reaches `requirement-ready` again, and only then refreshes Plan projections.

## Handoff

Return the source/authority and, when admitted, the artifact path; then return the activated desired contract, known exclusions and preservation, observable acceptance, current facts versus assumptions, and any resolved/superseded decisions through the runtime Change Contract. Task Execution may then project Goal, Done When, and material Boundaries into a Task Anchor. Requirement Definition does not derive implementation steps.

[workflow-state:requirements]
Resolve only desired meaning. Return `requirement-ready` or one minimum normative question; an admitted durable Requirement is still not an implementation Plan or mutation.
[/workflow-state:requirements]
