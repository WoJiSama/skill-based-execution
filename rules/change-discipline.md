# Change Discipline

Read this once before the first mutation in a modifying workflow. It owns mutation safety; task workflows keep only their trigger, immediate action, and completion responsibility.

## Semantic Boundary

- Establish the invariant, source of truth, ownership/provenance, producer-to-consumer chain, and affected full/incremental/read/write paths before choosing repair depth.
- Default to Product Development: make the smallest semantically complete change at the boundary that owns the invariant. Dependency count is risk evidence, not permission to preserve an incomplete repair.
- Use Operational Stabilization only for an explicit incident, availability, hotfix, or frozen-scope constraint; make containment reversible and report the structural repair still open.

## Mutation Boundary

- Touch only task-owned files; preserve unrelated local changes and existing style.
- Read the target project's own declared rules when the planned mutation reaches their scope; SBE adds no project rules of its own and never writes any into the target project.
- Update canonical sources before generated/copied consumers, and use the owning sync path rather than hand-editing derived output.
- Avoid unrelated renaming, formatting, cleanup, or deletion. Remove only artifacts made obsolete by the requested change.
- Do not mutate until the requested outcome is concrete enough to verify and every required user decision is resolved.

## Check

Can every changed line be traced to the requested outcome, an affected semantic path, or a required generated/validation target, with unrelated work preserved?
