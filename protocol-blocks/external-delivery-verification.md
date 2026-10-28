# External Delivery Verification

Load this protocol only when the user requested commit, push, MR/PR, deploy, publish, database delivery, or another shared-system artifact. It verifies existing authority; it never grants it or declares task completion.

## Requested Artifact Set

Before delivery or status readback, bind a session-only requested artifact set when the current task requests two or more external/shared artifacts, spans more than one repository or system owner, or the user asks an aggregate completion question such as "is everything done?" Derive its artifacts and requested terminal states only from the current explicit user request and the Governing Requirement, as projected into the active Task Anchor. Plans may attach only an already-bound item's technical identity (repository/system owner, source, target, ref, or version), delivery ordering, and authoritative readback; a Plan cannot add, omit, narrow, or modify an artifact or requested terminal state. Historical tasks, adjacent repositories or systems, touched tools, and likely follow-on work do not enter the set unless the current user request or Governing Requirement explicitly includes them. A changed or conflicting artifact, owner, terminal state, or scope returns `premise-changed` for Requirement Definition and Task Execution to rebind before delivery.

Each item records only its natural artifact label, owning repository/system, requested terminal state, authoritative readback, and current typed result. The set is runtime state only: create no ledger, database, or persistent status file. For a single artifact, Verify step 1 is the compact equivalent and no set needs to be presented.

Before answering an aggregate status question, reconstruct the bound set and read every item's authoritative source. Report each requested artifact and aggregate only over that set: do not import unrequested historical/adjacent work, and do not omit a requested artifact because another repository or system reached a nearby state.

Never substitute adjacent delivery states. Local readiness is not a commit; a commit is not a pushed branch; a pushed branch is not an MR/PR; an approved MR/PR is not a merged MR/PR; a merge is not downstream assembly; and assembly is not deployment or publication. The requested terminal state controls completion: approval can satisfy an approval request but cannot satisfy a merge request.

## Verify

1. For each requested artifact, name the authorized action, expected artifact, owning repository/system, target/source identity, requested terminal state, and exact readback before delivery.
2. Verify the real artifact rather than a precursor: inspect commit/ref, remote branch, MR/PR URL and state, deployed runtime, published output, migration/version artifact, or authoritative schema/data readback as applicable.
3. For database delivery, never infer execution from a reviewed SQL sibling or application build. Require the project-owned migration/version artifact plus authoritative schema/data proof.
4. Return `stale` when source content, branch/config inputs, or relevant verification changed. Return `premise-changed` when the requested artifact, target, authority, or delivery scope/premise changed; Task Closure sends the task back to fitted verification or Task Execution.
5. Return `blocked` for authorization, credentials, conflict, policy, network, or target-state failure. Retry only the external boundary when verified local inputs remain unchanged.

## Result

Return one typed result with evidence for each artifact and one aggregate result: `verified`, `blocked`, `stale`, or `premise-changed`. The aggregate is `verified` only when every item is `verified`; otherwise return the result that determines the next action, in `premise-changed` -> `stale` -> `blocked` order, while preserving every item result. Only aggregate `verified` can be consumed toward `Closure Complete`.

Rationalizations to reject:

- “The branch was pushed, so the requested MR probably exists.” Verify the actual MR/PR.
- “The MR was approved, so the requested merge is complete.” Read the actual merge state.
- “The Plan mentions another delivery, so it is part of completion.” A Plan can identify and order only artifacts already bound by the user request and Governing Requirement.
- “A neighboring repository was involved, so its likely follow-on artifact is also part of this task.” Only the user request and Governing Requirement bind the requested set.
- “A login/network retry means every local test must run again.” Re-run only the blocked boundary unless an input changed.
