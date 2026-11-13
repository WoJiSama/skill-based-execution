#!/usr/bin/env bash
# Compare SBE's recorded sync point with one verified upstream commit.
# Usage: upstream-status.sh [--upstream <path-or-url>] [--local]
# --local compares a local HEAD snapshot without claiming remote freshness.
# Exit: 0 = same commit, 1 = behind, 2 = cannot determine.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
up=""; local_only=0; scratch=""
trap 'if [[ -n "$scratch" ]]; then rm -rf "$scratch"; fi' EXIT
fail() { echo "STATUS: unknown — $*" >&2; exit 2; }
while [[ $# -gt 0 ]]; do
  case "$1" in
    --upstream)
      [[ $# -ge 2 && -n "$2" && "$2" != --* ]] || fail '--upstream requires a path or URL'
      up="$2"; shift 2 ;;
    --local) local_only=1; shift ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) fail "unexpected argument: $1" ;;
  esac
done
synced=$(awk -F': ' '/^synced_sha:/{print $2}' "$root/.upstream-sync" 2>/dev/null) || fail 'cannot read .upstream-sync'
[[ "$synced" =~ ^[0-9a-fA-F]{40}$|^[0-9a-fA-F]{64}$ ]] || fail 'no valid synced_sha in .upstream-sync'
if [[ -z "$up" ]]; then
  up="$HOME/IdeaProjects/skill-based-architecture"
  if ! git -C "$up" rev-parse --git-dir >/dev/null 2>&1; then
    up="https://github.com/WoJiSama/skill-based-architecture.git"
  fi
fi
if git -C "$up" rev-parse --git-dir >/dev/null 2>&1; then
  upstream_repo="$up"
else
  [[ "$local_only" -eq 0 ]] || fail '--local requires an existing local Git repository'
  [[ ! -e "$up" && "$up" != /* && "$up" != .* ]] || fail "not a Git repository: $up"
  scratch="$(mktemp -d)"
  git clone -q -- "$up" "$scratch/upstream" || fail 'cannot clone upstream'
  upstream_repo="$scratch/upstream"
fi
source_status=$(git -C "$upstream_repo" status --porcelain) || fail 'cannot inspect upstream worktree'
if [[ -n "$source_status" ]]; then
  echo 'Source worktree has uncommitted edits; excluded from the comparison. Treat any port from those edits as a candidate, not part of synced_sha.'
fi
if [[ "$local_only" -eq 1 ]]; then
  target_ref=HEAD
  target_description='local HEAD snapshot; remote freshness not checked'
else
  branch=$(git -C "$upstream_repo" symbolic-ref --quiet --short HEAD) || fail 'detached upstream checkout; use --local for snapshot-only diagnosis'
  remote=$(git -C "$upstream_repo" config --get-all "branch.$branch.remote") || fail 'upstream branch has no configured tracking remote'
  merge_ref=$(git -C "$upstream_repo" config --get-all "branch.$branch.merge") || fail 'upstream branch has no configured tracking ref'
  [[ -n "$remote" && "$remote" != . && "$remote" != *$'\n'* && "$merge_ref" == refs/heads/* && "$merge_ref" != *$'\n'* ]] || fail 'ambiguous tracking target; use --local for snapshot-only diagnosis'
  git -C "$upstream_repo" fetch -q --no-tags -- "$remote" "$merge_ref" || fail 'fetch failed; remote freshness is unknown'
  target_ref=FETCH_HEAD
  target_description="fetched $merge_ref from $remote"
fi
target_sha=$(git -C "$upstream_repo" rev-parse --verify "${target_ref}^{commit}") || fail 'comparison target is not a commit'
echo "synced_sha : $synced"
echo "target_sha : $target_sha ($target_description)"
git -C "$upstream_repo" cat-file -e "${synced}^{commit}" 2>/dev/null || fail 'recorded sync commit is unavailable; do not infer current or behind'
if [[ "$synced" = "$target_sha" ]]; then
  echo 'STATUS: up to date with the comparison target'
  exit 0
fi
git -C "$upstream_repo" merge-base --is-ancestor "$synced" "$target_sha" || fail 'recorded sync commit is not an ancestor of the comparison target; reconcile ahead/diverged history'
count=$(git -C "$upstream_repo" rev-list --count "$synced..$target_sha") || fail 'cannot compare history'
echo "STATUS: behind by $count commit(s)"
# Headings identify entries across both carriers, so archival is neither a new
# entry nor a reason to omit a change first seen in the archive.
[[ -n "$scratch" ]] || scratch="$(mktemp -d)"
notes_at() {
  local revision="$1" source
  for source in UPSTREAM-CHANGES.md UPSTREAM-CHANGES-archive.md; do
    if git -C "$upstream_repo" cat-file -e "$revision:$source" 2>/dev/null; then
      git -C "$upstream_repo" show "$revision:$source" |
        awk -v source="$source" '/^## [0-9][0-9][0-9][0-9]-/ { print $0 "\t" source }'
    fi
  done
}
notes_at "$synced" > "$scratch/base-notes"
notes_at "$target_sha" > "$scratch/target-notes"
new_notes=$(awk -F '\t' 'FILENAME == ARGV[1] { seen[$1]=1; next } !seen[$1]++ { print "  " $1 " [" $2 "]" }' "$scratch/base-notes" "$scratch/target-notes")
if [[ -n "$new_notes" ]]; then
  echo 'New UPSTREAM-CHANGES entries at target_sha:'
  printf '%s\n' "$new_notes"
else
  echo 'No newly added dated headings; inspect the commit diff before deciding what applies.'
fi
exit 1
