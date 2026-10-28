# Update From Upstream

Use when the user says the upstream skill-based-architecture (SBA) project changed and asks to update SBE. The user should not run diffs; the agent owns comparison, patching, and validation.

<!-- upstream-source: repo=https://github.com/WoJiSama/skill-based-architecture.git -->

## Posture

SBE is an **adapted downstream**, not a byte-identical one: SBA embeds architecture into projects, SBE is a stateless portable skill, and memory/embedding machinery is deliberately absent. `sync-manifest.yaml` records, for every file, whether it is `vendor` (byte-identical upstream mechanism; safe to overwrite when it matches the recorded base) or `adapted` (semantic merge by hand). Upstream improvements that concern removed machinery (read ledgers, session memory, shell generation, domain routing, knowledge reconciliation) are understood, then consciously not adopted; record that decision in the final report, not in a new file.

## Hard Rules

1. **No blind overwrite** — never copy an upstream file over an SBE file without reading both.
2. **Removed machinery stays removed** — do not reintroduce read ledgers, session-memory files, memory routing, domain routing, shell/registration generation, or knowledge-reconciliation workflows. `scripts/smoke-test.sh` fails on their markers.
3. **Agent does the diff** — ask the user only when a semantic conflict cannot be resolved from local evidence.
4. **Patch, don't replace** — apply upstream improvements as small edits; whole-file replacement is allowed only for `vendor` files that match the recorded base or for files verified to be unmodified old upstream copies.
5. **Upstream notes stay upstream** — read SBA's `UPSTREAM-CHANGES.md` for entries since `.upstream-sync`'s `synced_sha`; never create or copy a changelog into SBE.

## Procedure

1. **Preflight** — `git status --short`; note existing local changes and do not revert them. Run `bash scripts/smoke-test.sh` and `bash scripts/check-conformance.sh` first so failures introduced by this refresh are distinguishable from pre-existing ones.
2. **Fetch upstream** — clone or update a local copy:
   ```bash
   tmp="$(mktemp -d)"
   git clone https://github.com/WoJiSama/skill-based-architecture.git "$tmp/upstream"
   ```
   A local checkout (e.g. `~/IdeaProjects/skill-based-architecture`) may substitute when offline.
3. **Read the change list** — read `UPSTREAM-CHANGES.md` entries added since the recorded `synced_sha` in `.upstream-sync`. Skip entries marked `superseded` or `deprecated`. That list is the work-list; use it as a map, not as proof a file must change.
4. **Sync vendor files mechanically** — for each `vendor` entry in `sync-manifest.yaml`: if the local file matches the upstream version at the recorded base (`git -C "$tmp/upstream" show <synced_sha>:templates/skill/<path>`), copy the new upstream version in; if it differs, report LOCAL-EDIT and reconcile by hand.
5. **Merge adapted files semantically** — for each `adapted` entry whose upstream source changed, read both versions, port the improvement while keeping the stateless adaptation, and keep the entry's `notes` current.
6. **Scan for new mechanisms** — new upstream files under `templates/skill/workflows/`, `protocol-blocks/`, or `rules/` with no SBE counterpart are evaluated once: adopt (add to `sync-manifest.yaml` with the right class) or consciously skip (memory/embedding machinery, or no portable pressure yet). Skipping for now is the default; record it in the final report.
7. **Validate**:
   ```bash
   bash scripts/smoke-test.sh
   bash scripts/check-conformance.sh
   ```
   Update `conformance.yaml` in the same change when an adopted upstream mechanism adds a mandatory phrase, so the anchors keep matching reality.
8. **Update the sync pointer**:
   ```bash
   printf 'upstream: %s\nsynced_sha: %s\nsynced_date: %s\n' \
     "https://github.com/WoJiSama/skill-based-architecture" \
     "$(git -C "$tmp/upstream" rev-parse HEAD)" "$(date +%F)" > .upstream-sync
   ```
9. **Final report** — list upstream entries consulted, changes adopted, local adaptations preserved, mechanisms consciously skipped with reasons, validation results, and any unresolved semantic conflict.

## Stop Conditions

- Upstream cannot be fetched and no local upstream path is available.
- A file has both upstream mechanism changes and local semantic rewrites that cannot be reconciled from evidence.
- Validation fails after the merge and the cause is not isolated.

Do not solve stop conditions by overwriting SBE's stateless design or reintroducing removed machinery.
