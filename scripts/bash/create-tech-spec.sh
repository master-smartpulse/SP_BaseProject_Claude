#!/usr/bin/env bash

set -e

JSON_MODE=false
SHORT_NAME=""
BRANCH_NUMBER=""
ARGS=()
i=1
while [ $i -le $# ]; do
    arg="${!i}"
    case "$arg" in
        --json) JSON_MODE=true ;;
        --short-name)
            if [ $((i + 1)) -gt $# ]; then
                echo 'Error: --short-name requires a value' >&2
                exit 1
            fi
            i=$((i + 1))
            next_arg="${!i}"
            if [[ "$next_arg" == --* ]]; then
                echo 'Error: --short-name requires a value' >&2
                exit 1
            fi
            SHORT_NAME="$next_arg"
            ;;
        --number)
            if [ $((i + 1)) -gt $# ]; then
                echo 'Error: --number requires a value' >&2
                exit 1
            fi
            i=$((i + 1))
            next_arg="${!i}"
            if [[ "$next_arg" == --* ]]; then
                echo 'Error: --number requires a value' >&2
                exit 1
            fi
            case "$next_arg" in
                ''|*[!0-9]*)
                    echo 'Error: --number requires a numeric value' >&2
                    exit 1
                    ;;
            esac
            BRANCH_NUMBER="$next_arg"
            ;;
        --help|-h)
            echo "Usage: $0 [--json] [--short-name NAME] [--number N] DESCRIPTION"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
    i=$((i + 1))
done

DESCRIPTION="${ARGS[*]}"
if [ -z "$DESCRIPTION" ]; then
    echo "Usage: $0 [--json] DESCRIPTION" >&2
    exit 1
fi

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

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
    BRANCH_SUFFIX=$(clean_branch_name "$DESCRIPTION" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//')
fi
[ -z "$BRANCH_SUFFIX" ] && BRANCH_SUFFIX="fix"

BRANCH_SUFFIX="${BRANCH_SUFFIX}-tech"

if [ -z "$BRANCH_NUMBER" ]; then
    BRANCH_NUMBER=$(next_feature_number "$SPECS_DIR" "$HAS_GIT")
fi

FEATURE_NUM=$(printf "%03d" "$((10#$BRANCH_NUMBER))")
BRANCH_NAME=$(build_branch_name "$FEATURE_NUM" "$BRANCH_SUFFIX")

if [ "$HAS_GIT" = true ]; then
    git checkout -b "$BRANCH_NAME"
fi

FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

TEMPLATE="$REPO_ROOT/templates/spec-template-tech.md"
SPEC_FILE="$FEATURE_DIR/spec-tech.md"
if [ -f "$TEMPLATE" ]; then
    cp "$TEMPLATE" "$SPEC_FILE"
else
    touch "$SPEC_FILE"
fi

if $JSON_MODE; then
    printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' "$BRANCH_NAME" "$SPEC_FILE" "$FEATURE_NUM"
else
    echo "BRANCH_NAME: $BRANCH_NAME"
    echo "SPEC_FILE: $SPEC_FILE"
    echo "FEATURE_NUM: $FEATURE_NUM"
fi
