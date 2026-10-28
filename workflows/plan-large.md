# Large Plan Extension

Read this file only after `plan-feature.md` classifies the task as **Large** because evidence shows multi-subsystem scope, irreversible/expensive change, high uncertainty, or many decision-bearing unknowns. Large changes analysis depth, not artifact count.

## Multi-Perspective Analysis

Select perspectives incrementally after the current Design Slice exposes a decision that needs them. Analyze them in the conversation, harness-native Plan, or the current integrated artifact; a perspective is not a file. A suspected risk or consumer list is a candidate queue, not permission to open every perspective at once.

| Possible perspective | What it decides |
|---|---|
| Architecture | boundaries, owners, components, data/state flow |
| Domain | entities, lifecycle, state machine, invariants |
| Data and contracts | schema/API/event/cardinality/uniqueness, compatibility and migration |
| Integration and impact | semantic callers/readers/writers, copies/merges/deletes, cross-repo/service effects |
| Risk and quality | consistency, concurrency, performance, availability, permission, recovery |
| Rollout and proof | sequencing, staged activation, rollback, observability, acceptance |
| Decomposition | build order, shared interfaces, independent dispatch cut-points |

Compare user-confirmed desired behavior, architecture/contracts, and current code/tests/runtime without turning current implementation into desired truth.

## Angle Contract

Each selected angle closes one or more Design Slices and states:

1. its decision question and current evidence;
2. Current -> Target ownership/flow/model change;
3. chosen decision plus semantic impact;
4. activated risk treatment and proof;
5. remaining uncertainty or blocker.
