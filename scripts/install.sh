#!/usr/bin/env bash
# Install skill-based-execution into a tool-discoverable skills directory.
#
#   bash scripts/install.sh                 # symlink to ~/.agents/skills/skill-based-execution
#   bash scripts/install.sh --copy          # rsync copy instead (re-run after updates)
#   bash scripts/install.sh --copy ~/dir    # custom destination
#
# Symlink is preferred during development: `git pull` takes effect immediately.
# If your tool cannot follow symlinks, use --copy and re-run after every update.
set -euo pipefail
src="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode=link
dest="$HOME/.agents/skills/skill-based-execution"
if [ "${1:-}" = "--copy" ]; then mode=copy; fi
if [ -n "${2:-}" ]; then dest="$2"; fi

mkdir -p "$(dirname "$dest")"
if [ "$mode" = link ]; then
  if [ -L "$dest" ]; then rm "$dest"; fi
  if [ -e "$dest" ]; then
    echo "refusing to overwrite non-symlink destination: $dest" >&2; exit 1
  fi
  ln -s "$src" "$dest"
  echo "linked: $dest -> $src"
else
  rsync -a --delete --exclude '.git' "$src/" "$dest/"
  echo "copied to: $dest (re-run install.sh after every update)"
fi
