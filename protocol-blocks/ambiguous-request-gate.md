# Ambiguous Request Gate

Use this before mutation when wording leaves the requested outcome unclear. Vague wording is a signal, not an automatic blocker: the Agent should improve its decision view before transferring technical discovery back to the user.

## Evidence-First Decision

1. Route the request by its likely intent and inspect the smallest read-only evidence set that can resolve it: loaded rules, code, docs, config, tests, runtime evidence, and prior Session context.
2. Derive the likely technical scope, constraints, and verifiable outcome. Separate confirmed facts, reasonable assumptions, and unknowns.
3. Proceed with bounded investigation when evidence can narrow the problem. Surface non-blocking assumptions without asking the user to choose details the repository can answer.
4. Ask one minimum question only when the remaining unknown is a normative product or business preference, an authority boundary, or a choice that produces materially different outcomes.
5. Do not mutate until the requested outcome is concrete enough to verify.

## Implementation-Fact Question Gate

Before asking a product or business question, let [`change-contract.md`](change-contract.md) identify whether the blocker is normative; when the missing fact is a technical entry/owner/path/symbol/change point, use [`source-localization.md`](source-localization.md) instead of asking the user, then close the smallest decision-relevant implementation path: trigger/entry, caller chain, actual write target and target branch/state, ordering or progression, guards/protection/validation/failure behavior, and UI/API ownership. Omit irrelevant dimensions, but do not stop while a decision-bearing hop remains untraced.

Establish current implementation facts from code, tests, configuration, contracts, traces, or runtime evidence; never ask the user to choose them. Trace distinct flows independently before relating them. Ask only the remaining normative ambiguity that could change the expected outcome, business invariant, authority boundary, or failure policy. If the user says the answer is in code, stop asking and finish the trace first.

## Boundaries

- Read-only discovery is allowed when it directly reduces the request ambiguity; speculative implementation or architecture is not.
- A concrete module/file is not required when evidence can identify the owning boundary.
- Prior-turn scope remains valid until contradicted.
- If evidence exposes several plausible product outcomes, report the distinction and ask for the missing owner decision; do not silently select one.

## Failure Modes

- Lexical stop: treating `refactor / optimize / clean up / 整理 / 重构 / 优化` as blockers without reading project evidence.
- User-as-index: asking which file or module before checking the repository's source of truth.
- Speculative plan: proposing phases or target architecture before the outcome and constraints are evidenced.
- Hidden assumption: mutating on an unresolved product preference instead of requesting the minimum clarification.
- Owner inversion: redefining the Requirement Contract or source-localization stages here instead of consuming their blocker and returning one minimum question.
