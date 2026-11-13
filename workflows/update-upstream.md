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
5. **Upstream notes stay upstream** — read SBA's active and archived `UPSTREAM-CHANGES` entries since `.upstream-sync`'s `synced_sha`; never create or copy a changelog into SBE.

## Procedure

1. **Preflight** — `git status --short`; note existing local changes and do not revert them. Run `bash scripts/upstream-status.sh` (add `--upstream <path-or-url>` for another SBA source) and retain its exact `target_sha` and comparison scope in this Session. Exit 0 means the recorded commit matches, 1 means behind and supplies the work-list, and 2 means the target/history is unknown and must be resolved before claiming freshness. The default fetches the configured tracking target; explicit `--local` diagnoses a committed local snapshot without checking remote freshness. Run `bash scripts/smoke-test.sh` and `bash scripts/check-conformance.sh` first so failures introduced by this refresh are distinguishable from pre-existing ones.
2. **Bind the source revision** — use the local source inspected in Step 1, or clone a copy when needed:
   ```bash
   tmp="$(mktemp -d)"
   git clone https://github.com/WoJiSama/skill-based-architecture.git "$tmp/upstream"
   ```
   Verify that the Step 1 `target_sha` exists in that copy. Read committed sources with `git show <target_sha>:<path>`; neither a later moving HEAD nor uncommitted edits replace the comparison revision. A requested port from worktree edits is a candidate adaptation and must be reported separately from committed upstream coverage.
3. **Read the change list** — read new entries from both `UPSTREAM-CHANGES.md` and `UPSTREAM-CHANGES-archive.md` at `target_sha`. An entry moved into the archive is not new; a new entry already archived still applies. Skip entries marked `superseded` or `deprecated`. That list is a map, not proof a file must change; inspect the committed diff when headings do not explain changed mechanisms.
4. **Sync vendor files mechanically** — preserve the local `sync-manifest.yaml` selection. For each selected `vendor` entry: if the local file matches the upstream version at the recorded base (`git show <synced_sha>:<source>`), copy its source at `target_sha`; if it differs, report LOCAL-EDIT and reconcile by hand. Do not import an upstream manifest or expand the selected set merely to match the scaffold.
5. **Merge adapted files semantically** — for each selected `adapted` entry whose source changed between the recorded base and `target_sha`, read both versions, port the improvement while keeping the stateless adaptation, and keep the entry's `notes` current.
6. **Scan for new mechanisms** — new upstream files under `templates/skill/workflows/`, `protocol-blocks/`, or `rules/` with no SBE counterpart are evaluated once: adopt only when the requested scope and portable need justify it (add to `sync-manifest.yaml` with the right class), otherwise consciously skip. Skipping for now is the default; record the decision in the final report.
7. **Validate**:
   ```bash
   bash scripts/smoke-test.sh
   bash scripts/check-conformance.sh
   bash scripts/test-upstream-status.sh
   ```
   Update `conformance.yaml` in the same change when an adopted upstream mechanism adds a mandatory phrase, so the anchors keep matching reality.
8. **Update the sync pointer** — advance `.upstream-sync` to the exact `target_sha` only after every applicable selected change through that revision has an adopted or justified skipped outcome and validation passes. A partial refresh or worktree-candidate port leaves `synced_sha` unchanged. Preserve unrelated metadata, update the date, then read back the file and verify the recorded revision; a failed write/readback cannot become a successful sync claim.
9. **Final report** — give the comparison SHA and whether remote freshness was checked, entries consulted, changes adopted, local adaptations preserved, mechanisms consciously skipped with reasons, candidate changes outside the commit, validation results, and any unresolved semantic conflict. Distinguish partial adoption from a completed refresh.

## Stop Conditions

- The intended source revision or history cannot be verified; a failed remote fetch can support only explicitly scoped `--local` diagnosis, not a remote-current claim.
- A file has both upstream mechanism changes and local semantic rewrites that cannot be reconciled from evidence.
- Validation fails after the merge and the cause is not isolated.

Do not solve stop conditions by overwriting SBE's stateless design or reintroducing removed machinery.
