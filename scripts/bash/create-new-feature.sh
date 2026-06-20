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
            echo "  --json       Output in JSON format"
            echo "  --short-name Custom short name for the branch"
            echo "  --number N   Specify branch number manually"
            exit 0
            ;;
        *)
            ARGS+=("$arg")
            ;;
    esac
    i=$((i + 1))
done

FEATURE_DESCRIPTION="${ARGS[*]}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] [--short-name NAME] [--number N] DESCRIPTION" >&2
    exit 1
fi

generate_branch_name() {
    local description="$1"
    local stop_words="^(i|a|an|the|to|for|of|in|on|at|by|with|from|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|should|could|can|may|might|must|shall|this|that|these|those|my|your|our|their|want|need|add|get|set|o|os|as|e|ou|de|em|um|uma|uns|umas|da|do|das|dos|na|no|nas|nos|ao|aos|para|por|com|sem|que|como|ser|ter|seu|sua|seus|suas|meu|minha|nosso|nossa|quero|preciso|criar|adicionar|fazer|novo|nova)$"
    local clean_name=$(echo "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/ /g')
    local meaningful_words=()

    for word in $clean_name; do
        [ -z "$word" ] && continue
        if ! echo "$word" | grep -qiE "$stop_words"; then
            if [ ${#word} -ge 3 ]; then
                meaningful_words+=("$word")
            else
                word_upper=$(printf '%s' "$word" | tr '[:lower:]' '[:upper:]')
                if echo "$description" | grep -q "[[:<:]]${word_upper}[[:>:]]" 2>/dev/null || \
                   echo "$description" | grep -qw "$word_upper" 2>/dev/null; then
                    meaningful_words+=("$word")
                fi
            fi
        fi
    done

    if [ ${#meaningful_words[@]} -gt 0 ]; then
        local max_words=3
        [ ${#meaningful_words[@]} -eq 4 ] && max_words=4
        local result=""
        local count=0
        for word in "${meaningful_words[@]}"; do
            [ $count -ge $max_words ] && break
            [ -n "$result" ] && result="$result-"
            result="$result$word"
            count=$((count + 1))
        done
        echo "$result"
    else
        local cleaned=$(clean_branch_name "$description")
        echo "$cleaned" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//'
    fi
}

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
    BRANCH_SUFFIX=$(generate_branch_name "$FEATURE_DESCRIPTION")
fi
[ -z "$BRANCH_SUFFIX" ] && BRANCH_SUFFIX="feature"

if [ -z "$BRANCH_NUMBER" ]; then
    BRANCH_NUMBER=$(next_feature_number "$SPECS_DIR" "$HAS_GIT")
fi

FEATURE_NUM=$(printf "%03d" "$((10#$BRANCH_NUMBER))")
BRANCH_NAME=$(build_branch_name "$FEATURE_NUM" "$BRANCH_SUFFIX")

if [ "$HAS_GIT" = true ]; then
    git checkout -b "$BRANCH_NAME"
else
    >&2 echo "[specify] Warning: Git not detected; skipped branch creation"
fi

FEATURE_DIR="$SPECS_DIR/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

TEMPLATE="$REPO_ROOT/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"
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
