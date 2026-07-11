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

# Anchor on the script location, NOT on git: bootstrap runs before .git exists,
# and a git-based root would resolve to an enclosing repo when the kit is nested.
REPO_ROOT="$(CDPATH="" cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

GIT_TOPLEVEL=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
if [ -n "$GIT_TOPLEVEL" ] && [ "$GIT_TOPLEVEL" != "$REPO_ROOT" ]; then
    echo "WARNING: kit root ($REPO_ROOT) is nested inside another git repo ($GIT_TOPLEVEL)." >&2
    echo "Feature branches will be created in the enclosing repo. If that is not intended," >&2
    echo "move the kit to its own directory and run 'git init' there first." >&2
fi

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
if [ -d "$REPO_ROOT/.git" ]; then
    echo "  OK: git repository detected at kit root"
elif [ -n "$GIT_TOPLEVEL" ]; then
    echo "  Using enclosing git repository: $GIT_TOPLEVEL (see warning above)"
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
echo "  1. /constitution — fill in the Product Overview, 'Ratificada em' and adjust principles"
echo "  2. Adjust docs/arquitetura.md (product name; remove sections for platforms the project lacks)"
echo "  3. Review .claude/settings.json (main-protect and format hooks; .env permissions)"
echo "  4. /specify \"<first feature description>\""
echo ""
echo "Done. Kit version: $(cat VERSION 2>/dev/null || echo 'unknown')"
