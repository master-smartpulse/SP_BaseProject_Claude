#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  Checks prerequisites for /clarify: feature spec required."
            exit 0
            ;;
    esac
done

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

eval "$(get_feature_paths)"
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

if [[ ! -f "$FEATURE_SPEC" ]]; then
    echo "ERROR: No spec found in $FEATURE_DIR" >&2
    echo "Run /specify or /specify-tech first." >&2
    exit 1
fi

if $JSON_MODE; then
    printf '{"FEATURE_DIR":"%s","FEATURE_SPEC":"%s"}\n' \
        "$(json_escape "$FEATURE_DIR")" "$(json_escape "$FEATURE_SPEC")"
else
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo "FEATURE_SPEC: $FEATURE_SPEC"
fi
