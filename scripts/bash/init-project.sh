#!/usr/bin/env bash
# Bootstrap for adopting this kit in a new project (day-1).
# Mechanical steps only — content decisions (product vision, principles) belong to /constitution.

set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        --help|-h)
            echo "Usage: $0 [--dry-run]"
            echo "  Prepares a freshly copied kit for a new project:"
            echo "  - verifies required kit files are present"
            echo "  - initializes git when missing"
            echo "  - clears sample/leftover specs/ directories"
            echo "  - removes template-repo-only files (MELHORIAS_BASE_PROJECT.md)"
            echo "  - prints the day-1 checklist"
            exit 0
            ;;
    esac
done

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

REPO_ROOT=$(get_repo_root)
cd "$REPO_ROOT"

run() {
    if $DRY_RUN; then
        echo "[dry-run] $*"
    else
        "$@"
    fi
}

echo "== Verifying kit integrity =="
missing=0
for path in CLAUDE.md AGENTS.md .claude/commands .claude/agents .claude/skills templates scripts/bash memory/constitution.md docs/arquitetura.md FEATURE_LIST.md IMPLEMENTATION_STATUS.md; do
    if [ ! -e "$path" ]; then
        echo "  MISSING: $path" >&2
        missing=1
    fi
done
if [ "$missing" = "1" ]; then
    echo "ERROR: kit copy is incomplete — copy the missing paths from the base template first." >&2
    exit 1
fi
echo "  OK: all required kit paths present"

echo "== Git =="
if has_git; then
    echo "  OK: git repository detected"
else
    run git init
    echo "  Initialized git repository (feature branches require it)"
fi

echo "== Cleaning specs/ =="
if [ -d specs ]; then
    for dir in specs/*/; do
        [ -d "$dir" ] || continue
        run rm -rf "$dir"
        echo "  removed leftover: $dir"
    done
else
    run mkdir -p specs
fi
run touch specs/.gitkeep

echo "== Removing template-repo-only files =="
for f in MELHORIAS_BASE_PROJECT.md; do
    if [ -f "$f" ]; then
        run rm -f "$f"
        echo "  removed: $f"
    fi
done

echo ""
echo "== Day-1 checklist (do these next, inside a Claude Code session) =="
echo "  1. /constitution — preencha a Visão Geral do Produto, 'Ratificada em' e ajuste princípios"
echo "  2. Ajuste docs/arquitetura.md (nome do produto; remova seções de plataformas que o projeto não tem)"
echo "  3. Revise .claude/settings.json (hooks de main-protect e format; permissões de .env)"
echo "  4. /specify \"descrição da primeira feature\""
echo ""
echo "Done. Kit version: $(cat VERSION 2>/dev/null || echo 'unknown')"
