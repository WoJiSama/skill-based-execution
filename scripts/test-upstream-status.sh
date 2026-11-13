#!/usr/bin/env bash
# Behavioral regression fixtures use local Git remotes only and leave no repo state.
set -euo pipefail
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT
export GIT_CONFIG_NOSYSTEM=1
export GIT_CONFIG_GLOBAL=/dev/null
export GIT_AUTHOR_NAME='SBE test' GIT_COMMITTER_NAME='SBE test'
export GIT_AUTHOR_EMAIL='sbe-test@example.invalid' GIT_COMMITTER_EMAIL='sbe-test@example.invalid'
mkdir -p "$fixture/skill/scripts"
cp "$root/scripts/upstream-status.sh" "$fixture/skill/scripts/"
runner="$fixture/skill/scripts/upstream-status.sh"
git init -q --bare "$fixture/remote.git"
git init -q -b main "$fixture/seed"
printf '## 2026-01-01 - Existing entry\n' > "$fixture/seed/UPSTREAM-CHANGES.md"
git -C "$fixture/seed" add .
git -C "$fixture/seed" commit -qm base
base=$(git -C "$fixture/seed" rev-parse HEAD)
git -C "$fixture/seed" remote add origin "$fixture/remote.git"
git -C "$fixture/seed" push -qu origin main
git --git-dir="$fixture/remote.git" symbolic-ref HEAD refs/heads/main
git clone -q "$fixture/remote.git" "$fixture/checkout"
pin() { printf 'synced_sha: %s\n' "$1" > "$fixture/skill/.upstream-sync"; }
run_case() {
  local label="$1" expected="$2" actual=0
  shift 2
  bash "$runner" "$@" > "$fixture/output" 2>&1 || actual=$?
  if [[ "$actual" -ne "$expected" ]]; then
    cat "$fixture/output" >&2
    echo "FAIL $label: expected $expected, got $actual" >&2
    exit 1
  fi
  echo "PASS $label"
}
has() { grep -Fq -- "$1" "$fixture/output" || { cat "$fixture/output" >&2; echo "FAIL missing $1" >&2; exit 1; }; }
lacks() { if grep -Fq -- "$1" "$fixture/output"; then cat "$fixture/output" >&2; echo "FAIL unexpected $1" >&2; exit 1; fi; }
pin "$base"
run_case current 0 --upstream "$fixture/checkout"
has "target_sha : $base (fetched refs/heads/main from origin)"
# Local checkout remains at base while the authoritative remote advances.
mv "$fixture/seed/UPSTREAM-CHANGES.md" "$fixture/seed/UPSTREAM-CHANGES-archive.md"
printf '\n## 2026-01-02 - New archived entry\n' >> "$fixture/seed/UPSTREAM-CHANGES-archive.md"
printf '## 2026-01-03 - New active entry\n' > "$fixture/seed/UPSTREAM-CHANGES.md"
git -C "$fixture/seed" add .
git -C "$fixture/seed" commit -qm archive-and-new-entries
target=$(git -C "$fixture/seed" rev-parse HEAD)
git -C "$fixture/seed" push -q
run_case stale-checkout-and-archive-union 1 --upstream "$fixture/checkout"
has "target_sha : $target (fetched refs/heads/main from origin)"
has 'New archived entry [UPSTREAM-CHANGES-archive.md]'
has 'New active entry [UPSTREAM-CHANGES.md]'
lacks 'Existing entry'
[[ "$(git -C "$fixture/checkout" rev-parse HEAD)" = "$base" ]]
run_case explicit-local-snapshot 0 --upstream "$fixture/checkout" --local
has "target_sha : $base (local HEAD snapshot; remote freshness not checked)"
# Candidate edits are visible but never represented by a committed sync pointer.
printf '\n## 2026-01-04 - Uncommitted candidate\n' >> "$fixture/checkout/UPSTREAM-CHANGES.md"
run_case dirty-local-snapshot 0 --upstream "$fixture/checkout" --local
has 'uncommitted edits; excluded from the comparison'
lacks 'Uncommitted candidate'
run_case dirty-source-fetched-target 1 --upstream "$fixture/checkout"
has 'uncommitted edits; excluded from the comparison'
has "target_sha : $target"
git -C "$fixture/checkout" restore UPSTREAM-CHANGES.md
# A cached matching remote revision is never enough after a failed fresh fetch.
pin "$target"
git -C "$fixture/checkout" remote set-url origin "$fixture/missing-remote.git"
run_case fetch-failure-with-cached-current-target 2 --upstream "$fixture/checkout"
has 'fetch failed; remote freshness is unknown'
lacks 'STATUS: up to date'
git -C "$fixture/checkout" remote set-url origin "$fixture/remote.git"
pin 0000000000000000000000000000000000000001
run_case unavailable-base 2 --upstream "$fixture/checkout"
has 'recorded sync commit is unavailable'
pin invalid
run_case malformed-base 2 --upstream "$fixture/checkout"
has 'no valid synced_sha'
# A local-only branch is not an ancestor of the remote's competing history.
git -C "$fixture/checkout" commit --allow-empty -qm divergent-local
local_commit=$(git -C "$fixture/checkout" rev-parse HEAD)
pin "$local_commit"
run_case diverged-history 2 --upstream "$fixture/checkout"
has 'not an ancestor'
pin "$target"
run_case ahead-of-local-snapshot 2 --upstream "$fixture/checkout" --local
has 'not an ancestor'
pin "$base"
git -C "$fixture/checkout" checkout -q --detach "$base"
run_case detached-remote-target-unknown 2 --upstream "$fixture/checkout"
has 'detached upstream checkout'
run_case detached-explicit-local 0 --upstream "$fixture/checkout" --local
git -C "$fixture/checkout" checkout -q main
git -C "$fixture/checkout" config --unset branch.main.remote
run_case untracked-branch-target-unknown 2 --upstream "$fixture/checkout"
has 'no configured tracking remote'
run_case invalid-option 2 --unexpected
run_case missing-local-path 2 --upstream "$fixture/missing" --local
# Status inspection must not advance the downstream pointer.
[[ "$(cat "$fixture/skill/.upstream-sync")" = "synced_sha: $base" ]]
echo 'UPSTREAM STATUS REGRESSIONS PASSED (15 cases)'
