#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

parse_create_args "$@"

# --update: reuse the current feature branch/dir; never overwrite an existing spec
if [ "$UPDATE_MODE" = true ]; then
    REPO_ROOT=$(get_repo_root)
    reuse_feature_scaffold "$REPO_ROOT/templates/spec-template-tech.md" "spec-tech.md" "$JSON_MODE"
    exit 0
fi

DESCRIPTION="${ARGS[*]-}"
if [ -z "$DESCRIPTION" ]; then
    echo "Usage: $0 [--json] [--short-name NAME] [--number N] DESCRIPTION" >&2
    exit 1
fi

REPO_ROOT=$(get_repo_root)
if has_git; then
    HAS_GIT=true
else
    HAS_GIT=false
fi

cd "$REPO_ROOT"

SPECS_DIR="$REPO_ROOT/specs"
mkdir -p "$SPECS_DIR"

if [ -n "$SHORT_NAME" ]; then
    BRANCH_SUFFIX=$(clean_branch_name "$SHORT_NAME")
else
    BRANCH_SUFFIX=$(clean_branch_name "$DESCRIPTION" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//' || true)
fi
[ -z "$BRANCH_SUFFIX" ] && BRANCH_SUFFIX="fix"

BRANCH_SUFFIX="${BRANCH_SUFFIX}-tech"

if [ -z "$BRANCH_NUMBER" ]; then
    BRANCH_NUMBER=$(next_feature_number "$SPECS_DIR" "$HAS_GIT")
fi

FEATURE_NUM=$(printf "%03d" "$((10#$BRANCH_NUMBER))")
BRANCH_NAME=$(build_branch_name "$FEATURE_NUM" "$BRANCH_SUFFIX")

create_feature_scaffold "$BRANCH_NAME" "$FEATURE_NUM" "$REPO_ROOT/templates/spec-template-tech.md" "spec-tech.md" "$JSON_MODE"
