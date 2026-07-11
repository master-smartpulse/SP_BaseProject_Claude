#!/usr/bin/env bash
# Syncs kit-owned files from the base template into a derived project.
# Kit-owned (overwritten, extra content removed): .claude/, templates/, scripts/, AGENTS.md, VERSION
#   — except .claude/settings.local.* (machine-local, always preserved). Custom files you
#   added under kit-owned dirs are removed by the sync; keep customizations elsewhere or
#   re-apply after updating (use --dry-run to preview deletions).
# Project-owned (never touched by default): CLAUDE.md, memory/, docs/, specs/, FEATURE_LIST.md,
# IMPLEMENTATION_STATUS.md — review CHANGELOG.md of the base for manual follow-ups.

set -euo pipefail

SOURCE=""
REF=""
DRY_RUN=false
INCLUDE_CLAUDE_MD=false

while [ $# -gt 0 ]; do
    case "$1" in
        --source)
            [ $# -ge 2 ] || { echo "Error: --source requires a value" >&2; exit 1; }
            SOURCE="$2"; shift ;;
        --ref)
            [ $# -ge 2 ] || { echo "Error: --ref requires a value" >&2; exit 1; }
            REF="$2"; shift ;;
        --include-claude-md) INCLUDE_CLAUDE_MD=true ;;
        --dry-run) DRY_RUN=true ;;
        --help|-h)
            echo "Usage: $0 --source <path-or-git-url> [--ref <tag-or-branch>] [--include-claude-md] [--dry-run]"
            echo "  --source  Local path of the base template, or a git URL to clone"
            echo "  --ref     Tag/branch to use when --source is a git URL (default: default branch)"
            echo "  --include-claude-md  Also overwrite CLAUDE.md (skipped by default — projects customize it)"
            echo "  --dry-run Show what would change without writing"
            exit 0
            ;;
        *) echo "Error: unknown option '$1' (see --help)" >&2; exit 1 ;;
    esac
    shift
done

[ -n "$SOURCE" ] || { echo "Error: --source is required (see --help)" >&2; exit 1; }
command -v rsync >/dev/null 2>&1 || { echo "Error: rsync is required" >&2; exit 1; }
if [ -n "$REF" ] && [ -d "$SOURCE" ]; then
    echo "Warning: --ref is ignored when --source is a local path (using its current working tree)" >&2
fi

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(CDPATH="" cd "$SCRIPT_DIR/../.." && pwd)"

CLEANUP_DIR=""
trap '[ -n "$CLEANUP_DIR" ] && rm -rf "$CLEANUP_DIR"' EXIT
if [ -d "$SOURCE" ]; then
    SRC_DIR="$SOURCE"
else
    CLEANUP_DIR=$(mktemp -d)
    echo "Cloning $SOURCE ${REF:+(ref: $REF)} ..."
    if [ -n "$REF" ]; then
        git clone --depth 1 --branch "$REF" "$SOURCE" "$CLEANUP_DIR/base" >/dev/null 2>&1 || {
            echo "Error: could not clone $SOURCE at ref $REF" >&2; exit 1; }
    else
        git clone --depth 1 "$SOURCE" "$CLEANUP_DIR/base" >/dev/null 2>&1 || {
            echo "Error: could not clone $SOURCE" >&2; exit 1; }
    fi
    SRC_DIR="$CLEANUP_DIR/base"
fi

[ -d "$SRC_DIR/.claude" ] || { echo "Error: source does not look like the base template (missing .claude/)" >&2; exit 1; }

RSYNC_FLAGS="-a --delete"
$DRY_RUN && RSYNC_FLAGS="$RSYNC_FLAGS --dry-run -v"

echo "Base version: $(cat "$SRC_DIR/VERSION" 2>/dev/null || echo unknown) | Local version: $(cat "$REPO_ROOT/VERSION" 2>/dev/null || echo unknown)"

# Kit-owned directories: full sync (renames/removals propagate).
# Machine-local settings are always preserved.
for dir in .claude templates scripts; do
    echo "Syncing $dir/ ..."
    EXTRA_FLAGS=""
    [ "$dir" = ".claude" ] && EXTRA_FLAGS="--exclude=settings.local.*"
    # shellcheck disable=SC2086
    rsync $RSYNC_FLAGS $EXTRA_FLAGS "$SRC_DIR/$dir/" "$REPO_ROOT/$dir/"
done

# Kit-owned single files
for f in AGENTS.md VERSION; do
    if [ -f "$SRC_DIR/$f" ]; then
        echo "Syncing $f ..."
        # shellcheck disable=SC2086
        rsync $RSYNC_FLAGS "$SRC_DIR/$f" "$REPO_ROOT/$f"
    fi
done

if $INCLUDE_CLAUDE_MD && [ -f "$SRC_DIR/CLAUDE.md" ]; then
    echo "Syncing CLAUDE.md (requested via --include-claude-md) ..."
    # shellcheck disable=SC2086
    rsync $RSYNC_FLAGS "$SRC_DIR/CLAUDE.md" "$REPO_ROOT/CLAUDE.md"
fi

echo ""
echo "Done. Review the base template's CHANGELOG.md for changes that need manual follow-up"
echo "(e.g. constitution amendments, new workflow docs). Project-owned files were not touched."
