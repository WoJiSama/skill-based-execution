#!/usr/bin/env bash
# Behavior-anchor conformance check for skill-based-execution.
# Parses conformance.yaml (required_sections: file/must_contain/must_not_contain)
# and verifies every anchor phrase against the real file. Pure bash/awk.
set -u
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
manifest="${1:-conformance.yaml}"
[ -f "$manifest" ] || { echo "conformance manifest not found: $manifest" >&2; exit 2; }

fail=0
cur=""
mode=""
while IFS= read -r line; do
  case "$line" in
    "  - file: "*)
      cur="${line#"  - file: "}"
      if [ ! -f "$cur" ]; then
        printf 'FAIL  missing file: %s\n' "$cur"; fail=1
      fi
      mode="" ;;
    "    must_contain:")     mode=must ;;
    "    must_not_contain:") mode=not ;;
    "    "*)
      case "$line" in
        "      - \""*|*"      - '"*)
          phrase=$(printf '%s' "$line" | sed -E 's/^      - "(.*)",?$/\1/; s/^      - '"'"'(.*)'"'"',?$/\1/')
          [ -z "$cur" ] && continue
          if [ "$mode" = must ]; then
            if grep -Fq -- "$phrase" "$cur" 2>/dev/null; then
              printf '  ok  %s : contains "%s"\n' "$cur" "$phrase"
            else
              printf 'FAIL  %s : missing anchor "%s"\n' "$cur" "$phrase"; fail=1
            fi
          elif [ "$mode" = not ]; then
            if grep -Fq -- "$phrase" "$cur" 2>/dev/null; then
              printf 'FAIL  %s : forbidden phrase present "%s"\n' "$cur" "$phrase"; fail=1
            else
              printf '  ok  %s : free of "%s"\n' "$cur" "$phrase"
            fi
          fi ;;
        *) mode="" ;;
      esac ;;
  esac
done < "$manifest"

echo
if [ "$fail" -eq 0 ]; then echo "CONFORMANCE PASSED ($manifest)"; else echo "CONFORMANCE FAILED ($manifest)"; exit 1; fi
