# Refactor Fan-out Workflow

Use this only for one source-of-truth change with at least five independently editable usage sites. Five sites trigger cut-point analysis, not automatic workers. Single-region or coupled refactors use [`change-managed.md`](change-managed.md).

## Admission

Fan-out only when the transformation is identical across sites, at least two batches have non-overlapping writable ownership, each batch has a literal acceptance check, useful main-thread work overlaps execution, and concurrency saves more than contract/review/integration cost. Otherwise stay inline.

## Phase 1 — Map the Change

1. Read the source-of-truth definition and write the exact transformation.
2. Find every usage with grep/IDE/language-server evidence; keep a literal site list.
3. Group the fewest independent batches. Shared files belong to one owner or stay with the main agent.
4. For each candidate batch, define files, transformation, Forbidden Zones, acceptance check, expected parallel gain, and concurrent main-thread work.
5. Run the Admission test before dispatch.

## Phase 2 — Execute

When the harness offers independent workers, dispatch admitted batches together, pass only each batch's slice, forbid drive-by edits, and continue the named main-thread work; worker output is candidate evidence until reviewed. Without independent workers, run the batches sequentially with the same per-batch contract. Non-admitted batches always stay inline.

## Phase 3 — Integrate and Verify

For every batch, the main agent verifies owned files, literal acceptance, and absence of drive-bys. After integration, run one whole-repo check for the old pattern, the smallest cross-batch regression, and consistency of the new form.

Unexpected remaining sites, overlapping diffs, or inconsistent variants mean the cut-point was wrong; re-plan the remainder instead of preserving fan-out by inertia.

## Closure

Run [Task Closure](task-closure.md) exactly once after the integrated refactor. Workers report scoped evidence only; they do not close the task independently.

## Completion Check

Source-of-truth and all sites were enumerated; dispatch passed Net Benefit; ownership did not overlap; each batch and the whole repository were freshly verified; Task Closure ran once.
