#!/usr/bin/env bash
# Structure / budget / routing-sync / link checks for skill-based-execution.
# Pure bash + awk; no external dependencies. Exit 1 on any failure.
set -u
root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
fail=0
ok()  { printf '  ok  %s\n' "$1"; }
bad() { printf 'FAIL  %s\n' "$1"; fail=1; }

echo "== frontmatter and dual budget =="
head -1 SKILL.md | grep -q '^---$' || bad "SKILL.md must start with '---' frontmatter"
fm=$(awk 'NR==1&&$0=="---"{infm=1;next} infm&&$0=="---"{exit} infm{c++} END{print c+0}' SKILL.md)
body=$(awk 'NR==1&&$0=="---"{infm=1;next} infm&&$0=="---"{out=1;next} out{c++} END{print c+0}' SKILL.md)
[ "$fm" -le 25 ]  && ok "frontmatter ≤ 25 lines ($fm)"  || bad "frontmatter $fm lines > 25"
[ "$body" -le 90 ] && ok "body ≤ 90 lines ($body)"     || bad "body $body lines > 90"
grep -q '^name: skill-based-execution$' SKILL.md && ok "name matches directory" || bad "frontmatter name mismatch"

echo "== routing.yaml <-> SKILL.md sync =="
[ -f routing.yaml ] || bad "routing.yaml missing"
ids_yaml=$(awk '/^  - id: /{print $3}' routing.yaml)
[ -n "$ids_yaml" ] || bad "routing.yaml has no task ids"
for id in $ids_yaml; do
  grep -q "(\`$id\`)" SKILL.md && ok "route '$id' present in SKILL.md summary" || bad "route '$id' missing from SKILL.md ROUTING_SUMMARY"
done
ids_md=$(awk '/<!-- ROUTING_SUMMARY_START -->/{f=1;next} /<!-- ROUTING_SUMMARY_END -->/{f=0} f' SKILL.md \
  | grep -oE '\(`[a-z-]+`\)' | tr -d '(`)' | sort -u)
for id in $ids_md; do
  echo "$ids_yaml" | grep -qx "$id" && ok "SKILL.md summary id '$id' exists in routing.yaml" \
    || bad "SKILL.md summary id '$id' not in routing.yaml"
done
grep -q '^always_read: \[\]' routing.yaml && ok "always_read stays empty (stateless)" || bad "always_read must stay empty"

echo "== routed workflow files exist =="
for wf in $(awk '/^    workflow: /{print $2}' routing.yaml); do
  [ -f "$wf" ] && ok "workflow file $wf" || bad "routing.yaml points to missing $wf"
done

echo "== relative markdown links resolve =="
link_fail=0
while IFS= read -r md; do
  dir=$(dirname "$md")
  for target in $(grep -oE '\]\(([^)#]+)(#[^)]*)?\)' "$md" | sed -E 's/^\]\(//; s/(#[^)]*)?\)$//' | grep -v '^http' | grep -v '^mailto'); do
    if [ ! -e "$dir/$target" ]; then
      bad "broken link in $md: $target"; link_fail=1
    fi
  done
done < <(find . -name '*.md' -not -path './.git/*')
[ "$link_fail" -eq 0 ] && ok "all relative links resolve"

echo "== forbidden machinery markers (stateless guard) =="
scan_targets="SKILL.md routing.yaml"
scan_targets="$scan_targets $(find rules workflows protocol-blocks -name '*.md' | grep -v 'workflows/update-upstream.md' | tr '\n' ' ')"
marker_fail=0
for term in 'READ_REUSE' '读账本' 'SessionStart' 'domain-routing' 'rule-update/' 'update-rules\.md' 'sync-routing\.sh'; do
  hits=$(grep -IlE "$term" $scan_targets 2>/dev/null)
  if [ -n "$hits" ]; then bad "forbidden marker '$term' in: $(echo "$hits" | tr '\n' ' ')"; marker_fail=1; fi
done
[ "$marker_fail" -eq 0 ] && ok "no memory/embedding machinery markers in carried files"

echo "== upstream pin =="
grep -Eq '^synced_sha: [0-9a-f]{40}$' .upstream-sync && ok ".upstream-sync has a synced_sha" || bad ".upstream-sync synced_sha missing/malformed"

echo "== conformance files reference real files =="
conf_fail=0
for f in $(awk '/^  - file: /{print $3}' conformance.yaml); do
  [ -f "$f" ] || { bad "conformance.yaml anchors missing file $f"; conf_fail=1; }
done
[ "$conf_fail" -eq 0 ] && ok "conformance.yaml file targets exist"

echo
if [ "$fail" -eq 0 ]; then echo "SMOKE TEST PASSED"; else echo "SMOKE TEST FAILED"; exit 1; fi
