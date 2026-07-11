#!/usr/bin/env bash
# Self-tests for the kit's bash scripts. Run from anywhere:
#   bash scripts/tests/run-tests.sh
# Exercises the real flows in a throwaway git repo and asserts on outputs.

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_ROOT="$(CDPATH="" cd "$SCRIPT_DIR/../.." && pwd)"

PASS=0
FAIL=0

ok()   { PASS=$((PASS + 1)); echo "  ok: $1"; }
fail() { FAIL=$((FAIL + 1)); echo "  FAIL: $1" >&2; }

assert_eq() { # expected actual label
    if [ "$1" = "$2" ]; then ok "$3"; else fail "$3 (expected '$1', got '$2')"; fi
}

assert_json_key() { # json key expected label
    local actual
    actual=$(printf '%s' "$1" | python3 -c "import json,sys; print(json.load(sys.stdin).get('$2',''))" 2>/dev/null || echo "__parse_error__")
    assert_eq "$3" "$actual" "$4"
}

echo "== 1. Syntax check =="
for s in "$KIT_ROOT"/scripts/bash/*.sh "$KIT_ROOT"/scripts/bash/hooks/*.sh; do
    if bash -n "$s"; then ok "syntax $(basename "$s")"; else fail "syntax $(basename "$s")"; fi
done

echo "== 2. Sandbox setup =="
# pwd -P resolves symlinks (macOS mktemp returns /var/... -> /private/var/...)
SANDBOX=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$SANDBOX"' EXIT
cp -R "$KIT_ROOT/scripts" "$SANDBOX/"
cp -R "$KIT_ROOT/templates" "$SANDBOX/"
cd "$SANDBOX"
git init -q
git -c user.email=test@test -c user.name=test add -A
git -c user.email=test@test -c user.name=test -c alias.ci=commit ci -qm init
git branch -m main
ok "sandbox created"

echo "== 3. create-new-feature: transliteration + JSON =="
OUT=$(bash scripts/bash/create-new-feature.sh --json "Autenticação de Usuários com Ações" 2>/dev/null)
assert_json_key "$OUT" "BRANCH_NAME" "001-autenticacao-usuarios-acoes" "branch transliterated (pt-BR accents)"
assert_json_key "$OUT" "FEATURE_NUM" "001" "feature number"
[ -f "specs/001-autenticacao-usuarios-acoes/spec.md" ] && ok "spec.md created from template" || fail "spec.md missing"

echo "== 4. create-new-feature --update: no overwrite =="
echo "conteudo preenchido" > specs/001-autenticacao-usuarios-acoes/spec.md
OUT=$(bash scripts/bash/create-new-feature.sh --json --update 2>/dev/null)
assert_json_key "$OUT" "UPDATED" "true" "update mode reported"
assert_eq "conteudo preenchido" "$(cat specs/001-autenticacao-usuarios-acoes/spec.md)" "existing spec preserved"

echo "== 4b. transliteration under C locale (CI portability) =="
OUT=$(LC_ALL=C LANG=C bash -c 'source scripts/bash/common.sh && transliterate "Ação média"')
assert_eq "Acao media" "$OUT" "transliterate works without UTF-8 locale in env"

echo "== 5. setup-plan: keys + backup on rerun =="
OUT=$(bash scripts/bash/setup-plan.sh --json)
assert_json_key "$OUT" "BRANCH" "001-autenticacao-usuarios-acoes" "setup-plan branch"
KEYS=$(printf '%s' "$OUT" | python3 -c "import json,sys; print(','.join(sorted(json.load(sys.stdin))))")
assert_eq "BRANCH,FEATURE_DIR,FEATURE_SPEC,HAS_GIT,IMPL_PLAN" "$KEYS" "setup-plan JSON keys"
bash scripts/bash/setup-plan.sh --json >/dev/null 2>&1
[ -f "specs/001-autenticacao-usuarios-acoes/plan.md.bak" ] && ok "plan.md backed up on rerun" || fail "plan.md.bak missing"

echo "== 6. check-task-prerequisites: plan.md listed =="
OUT=$(bash scripts/bash/check-task-prerequisites.sh --json)
DOCS=$(printf '%s' "$OUT" | python3 -c "import json,sys; print(','.join(json.load(sys.stdin)['AVAILABLE_DOCS']))")
case "$DOCS" in *plan.md*) ok "plan.md in AVAILABLE_DOCS" ;; *) fail "plan.md not in AVAILABLE_DOCS ($DOCS)" ;; esac

echo "== 7. check-review-prerequisites: valid JSON with accented filename =="
touch 'specs/ação café.md'
OUT=$(bash scripts/bash/check-review-prerequisites.sh --json)
COUNT=$(printf '%s' "$OUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d['CHANGED_FILES']))" 2>/dev/null || echo "__parse_error__")
[ "$COUNT" != "__parse_error__" ] && [ "$COUNT" -ge 1 ] && ok "valid JSON with $COUNT changed files (UTF-8 safe)" || fail "check-review JSON invalid"

echo "== 8. check-spec-prerequisites =="
OUT=$(bash scripts/bash/check-spec-prerequisites.sh --json)
assert_json_key "$OUT" "FEATURE_SPEC" "$SANDBOX/specs/001-autenticacao-usuarios-acoes/spec.md" "check-spec FEATURE_SPEC"

echo "== 9. create-tech-spec: -tech suffix, branch from main =="
git checkout -q main
OUT=$(bash scripts/bash/create-tech-spec.sh --json "Correção de sessão expirada" 2>/dev/null)
BRANCH=$(printf '%s' "$OUT" | python3 -c "import json,sys; print(json.load(sys.stdin)['BRANCH_NAME'])")
case "$BRANCH" in *-tech) ok "tech suffix ($BRANCH)" ;; *) fail "missing -tech suffix ($BRANCH)" ;; esac
[ -f "specs/$BRANCH/spec-tech.md" ] && ok "spec-tech.md created" || fail "spec-tech.md missing"

echo "== 10. hooks: block on main, allow on feature branch =="
git checkout -q main
python3 -c "import json; open('p.json','w').write(json.dumps({'tool_input':{'command':'git '+'commit -m x'}}))"
if bash scripts/bash/hooks/pre-bash-guard.sh < p.json >/dev/null 2>&1; then
    fail "guard should block commit on main"
else
    ok "guard blocks commit on main (exit 2)"
fi
git checkout -q "$BRANCH"
if bash scripts/bash/hooks/pre-bash-guard.sh < p.json >/dev/null 2>&1; then
    ok "guard allows commit on feature branch"
else
    fail "guard should allow commit on feature branch"
fi
python3 -c "import json; open('p2.json','w').write(json.dumps({'tool_input':{'file_path':'x.ts'}}))"
if bash scripts/bash/hooks/post-edit-format.sh < p2.json >/dev/null 2>&1; then
    ok "post-edit-format no-ops without package.json"
else
    fail "post-edit-format should exit 0"
fi

echo "== 11. no-description usage errors =="
if bash scripts/bash/create-new-feature.sh --json >/dev/null 2>&1; then
    fail "create-new-feature should fail without description"
else
    ok "create-new-feature fails without description"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
