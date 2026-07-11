#!/usr/bin/env bash

set -euo pipefail

JSON_MODE=false
for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h)
            echo "Usage: $0 [--json]"
            echo "  Checks prerequisites for /review: feature directory required. Collects changed files."
            exit 0
            ;;
    esac
done

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

eval "$(get_feature_paths)"
check_feature_branch "$CURRENT_BRANCH" "$HAS_GIT" || exit 1

if [[ ! -d "$FEATURE_DIR" ]]; then
    echo "ERROR: Feature directory not found: $FEATURE_DIR" >&2
    echo "Run /specify first." >&2
    exit 1
fi

docs=()
[[ -f "$FEATURE_SPEC" ]] && docs+=("$(basename "$FEATURE_SPEC")")
[[ -f "$IMPL_PLAN" ]] && docs+=("plan.md")
[[ -f "$TASKS" ]] && docs+=("tasks.md")
[[ -f "$RESEARCH" ]] && docs+=("research.md")
[[ -f "$DATA_MODEL" ]] && docs+=("data-model.md")
[[ -d "$CONTRACTS_DIR" ]] && [[ -n "$(ls -A "$CONTRACTS_DIR" 2>/dev/null)" ]] && docs+=("contracts/")
[[ -f "$QUICKSTART" ]] && docs+=("quickstart.md")

changed_files=()
if [[ "$HAS_GIT" == "true" ]]; then
    main_branch="main"
    if git rev-parse --verify origin/main >/dev/null 2>&1; then
        main_branch="origin/main"
    elif git rev-parse --verify main >/dev/null 2>&1; then
        main_branch="main"
    elif git rev-parse --verify origin/master >/dev/null 2>&1; then
        main_branch="origin/master"
    elif git rev-parse --verify master >/dev/null 2>&1; then
        main_branch="master"
    fi

    merge_base=$(git merge-base "$main_branch" HEAD 2>/dev/null || echo "")
    if [[ -n "$merge_base" ]]; then
        while IFS= read -r file; do
            [[ -n "$file" ]] && changed_files+=("$file")
        done < <(git -c core.quotepath=false diff --name-only "$merge_base" HEAD 2>/dev/null)
    fi

    while IFS= read -r file; do
        [[ -n "$file" ]] && changed_files+=("$file")
    done < <(git -c core.quotepath=false diff --name-only HEAD 2>/dev/null)

    while IFS= read -r file; do
        [[ -n "$file" ]] && changed_files+=("$file")
    done < <(git -c core.quotepath=false diff --name-only --cached 2>/dev/null)

    while IFS= read -r file; do
        [[ -n "$file" ]] && changed_files+=("$file")
    done < <(git -c core.quotepath=false ls-files --others --exclude-standard 2>/dev/null)

    if [[ ${#changed_files[@]} -gt 0 ]]; then
        deduped=()
        while IFS= read -r file; do
            [[ -n "$file" ]] && deduped+=("$file")
        done < <(printf '%s\n' "${changed_files[@]}" | sort -u)
        changed_files=("${deduped[@]}")
    fi
fi

if $JSON_MODE; then
    json_docs=$(json_array ${docs[@]+"${docs[@]}"})
    json_changed=$(json_array ${changed_files[@]+"${changed_files[@]}"})

    printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":%s,"CHANGED_FILES":%s}\n' \
        "$(json_escape "$FEATURE_DIR")" "$json_docs" "$json_changed"
else
    echo "FEATURE_DIR: $FEATURE_DIR"
    echo ""
    echo "AVAILABLE_DOCS:"
    check_file "$FEATURE_SPEC" "$(basename "$FEATURE_SPEC")"
    check_file "$IMPL_PLAN" "plan.md"
    check_file "$TASKS" "tasks.md"
    check_file "$RESEARCH" "research.md"
    check_file "$DATA_MODEL" "data-model.md"
    check_dir "$CONTRACTS_DIR" "contracts/"
    check_file "$QUICKSTART" "quickstart.md"
    echo ""
    echo "CHANGED_FILES (${#changed_files[@]}):"
    for f in ${changed_files[@]+"${changed_files[@]}"}; do
        echo "  - $f"
    done
fi
