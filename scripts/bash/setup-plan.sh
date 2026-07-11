#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            exit 0
            ;;
    esac
done

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

eval "$(get_feature_paths)"

check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

mkdir -p "$FEATURE_DIR"

TEMPLATE="$REPO_ROOT/templates/plan-template.md"
IMPL_PLAN="$FEATURE_DIR/plan.md"
if [[ -f "$IMPL_PLAN" ]]; then
    cp "$IMPL_PLAN" "$IMPL_PLAN.bak"
    >&2 echo "[plan] Warning: existing plan.md backed up to plan.md.bak before reset from template"
fi
if [[ -f "$TEMPLATE" ]]; then
    cp "$TEMPLATE" "$IMPL_PLAN"
else
    touch "$IMPL_PLAN"
fi

if $JSON_MODE; then
    printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","FEATURE_DIR":"%s","BRANCH":"%s","HAS_GIT":"%s"}\n' \
        "$(json_escape "$FEATURE_SPEC")" "$(json_escape "$IMPL_PLAN")" "$(json_escape "$FEATURE_DIR")" \
        "$(json_escape "$CURRENT_BRANCH")" "$(json_escape "$HAS_GIT")"
else
    echo "FEATURE_SPEC: $FEATURE_SPEC"
    echo "IMPL_PLAN: $IMPL_PLAN"
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "BRANCH: $CURRENT_BRANCH"
    echo "HAS_GIT: $HAS_GIT"
fi
