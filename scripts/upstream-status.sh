#!/usr/bin/env bash
# One-command "am I behind the SBA upstream?" check for SBE.
#
#   bash scripts/upstream-status.sh                     # default local checkout, else remote HEAD
#   bash scripts/upstream-status.sh --upstream <path>   # explicit local SBA checkout
#
# With a local checkout it also lists the UPSTREAM-CHANGES.md entries added
# since the recorded sync point — the work-list for workflows/update-upstream.md.
set -u
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
repo="https://github.com/WoJiSama/skill-based-architecture"
synced=$(awk -F': ' '/^synced_sha:/{print $2}' "$root/.upstream-sync" 2>/dev/null)
[ -n "$synced" ] || { echo "ERROR: no synced_sha in .upstream-sync"; exit 2; }

up=""
if [ "${1:-}" = "--upstream" ] && [ -n "${2:-}" ]; then
  up="$2"
else
  for cand in "$HOME/IdeaProjects/skill-based-architecture"; do
    [ -d "$cand/.git" ] && up="$cand" && break
  done
fi

echo "synced_sha : $synced"
if [ -n "$up" ]; then
  head=$(git -C "$up" rev-parse HEAD 2>/dev/null) || { echo "ERROR: not a git repo: $up"; exit 2; }
  echo "upstream   : $head ($up @ origin/$(git -C "$up" branch --show-current 2>/dev/null))"
else
  echo "(no local upstream checkout; querying remote HEAD of $repo)"
  head=$(git ls-remote "$repo.git" HEAD 2>/dev/null | awk '{print $1}')
  [ -n "$head" ] || { echo "ERROR: cannot determine upstream HEAD (offline?)"; exit 2; }
  echo "upstream   : $head (remote)"
fi

if [ "$synced" = "$head" ]; then
  echo "STATUS: up to date"
  exit 0
fi

if [ -n "$up" ]; then
  count=$(git -C "$up" rev-list --count "$synced..$head" 2>/dev/null || echo "?")
  echo "STATUS: behind by $count commit(s) — run workflows/update-upstream.md"
  echo
  echo "UPSTREAM-CHANGES entries added since sync point:"
  git -C "$up" diff "$synced" "$head" -- UPSTREAM-CHANGES.md 2>/dev/null \
    | awk '/^\+## /{print "  " substr($0, 4)}' | head -30
else
  echo "STATUS: behind the remote HEAD — clone SBA locally and run workflows/update-upstream.md"
fi
