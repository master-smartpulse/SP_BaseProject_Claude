#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

parse_create_args "$@"

# --update: reuse the current feature branch/dir; never overwrite an existing spec
if [ "$UPDATE_MODE" = true ]; then
    REPO_ROOT=$(get_repo_root)
    reuse_feature_scaffold "$REPO_ROOT/templates/spec-template.md" "spec.md" "$JSON_MODE"
    exit 0
fi

FEATURE_DESCRIPTION="${ARGS[*]-}"
if [ -z "$FEATURE_DESCRIPTION" ]; then
    echo "Usage: $0 [--json] [--update] [--short-name NAME] [--number N] DESCRIPTION" >&2
    exit 1
fi

generate_branch_name() {
    local description="$1"
    local stop_words="^(i|a|an|the|to|for|of|in|on|at|by|with|from|is|are|was|were|be|been|being|have|has|had|do|does|did|will|would|should|could|can|may|might|must|shall|this|that|these|those|my|your|our|their|want|need|add|get|set|o|os|as|e|ou|de|em|um|uma|uns|umas|da|do|das|dos|na|no|nas|nos|ao|aos|para|por|com|sem|que|como|ser|ter|seu|sua|seus|suas|meu|minha|nosso|nossa|quero|preciso|criar|adicionar|fazer|novo|nova)$"
    local clean_name
    clean_name=$(transliterate "$description" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/ /g')
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
        local cleaned
        cleaned=$(clean_branch_name "$description")
        echo "$cleaned" | tr '-' '\n' | grep -v '^$' | head -3 | tr '\n' '-' | sed 's/-$//' || true
    fi
}

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

create_feature_scaffold "$BRANCH_NAME" "$FEATURE_NUM" "$REPO_ROOT/templates/spec-template.md" "spec.md" "$JSON_MODE"
