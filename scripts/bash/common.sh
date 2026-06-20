#!/usr/bin/env bash
# Common functions and variables for Spec-Driven Development scripts

get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        local script_dir="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../.." && pwd)
    fi
}

get_current_branch() {
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        git rev-parse --abbrev-ref HEAD
        return
    fi

    local repo_root=$(get_repo_root)
    local specs_dir="$repo_root/specs"

    if [[ -d "$specs_dir" ]]; then
        local latest_feature=""
        local highest=0

        for dir in "$specs_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname=$(basename "$dir")
                if [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done

        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    echo "main"
}

has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    if [[ "$has_git_repo" != "true" ]]; then
        echo "[specify] Warning: Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi

    return 0
}

find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/specs"

    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"
    local matches=()

    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done
    fi

    if [[ ${#matches[@]} -eq 0 ]]; then
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        echo "$specs_dir/${matches[0]}"
    else
        echo "ERROR: Multiple spec directories found with prefix '$prefix': ${matches[*]}" >&2
        echo "$specs_dir/$branch_name"
    fi
}

get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    local feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    # Features criadas via /specify-tech têm spec-tech.md em vez de spec.md;
    # FEATURE_SPEC aponta para o que existir.
    local feature_spec="$feature_dir/spec.md"
    if [[ ! -f "$feature_spec" && -f "$feature_dir/spec-tech.md" ]]; then
        feature_spec="$feature_dir/spec-tech.md"
    fi

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_spec'
SPEC_TECH='$feature_dir/spec-tech.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# --- Funções compartilhadas pelos scripts de criação (specify / specify-tech) ---

clean_branch_name() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
}

get_highest_from_specs() {
    local specs_dir="$1"
    local highest=0
    if [ -d "$specs_dir" ]; then
        for dir in "$specs_dir"/*; do
            [ -d "$dir" ] || continue
            local dirname=$(basename "$dir")
            local number=$(echo "$dirname" | grep -o '^[0-9]\+' || echo "0")
            number=$((10#${number:-0}))
            [ "$number" -gt "$highest" ] && highest=$number
        done
    fi
    echo "$highest"
}

get_highest_from_branches() {
    local highest=0
    local branches=$(git branch -a 2>/dev/null || echo "")
    if [ -n "$branches" ]; then
        while IFS= read -r branch; do
            local clean_branch=$(echo "$branch" | sed 's/^[* ]*//; s|^remotes/[^/]*/||')
            if echo "$clean_branch" | grep -q '^[0-9]\{3\}-'; then
                local number=$(echo "$clean_branch" | grep -o '^[0-9]\{3\}' || echo "0")
                number=$((10#${number:-0}))
                [ "$number" -gt "$highest" ] && highest=$number
            fi
        done <<< "$branches"
    fi
    echo "$highest"
}

next_feature_number() {
    local specs_dir="$1"
    local has_git_repo="$2"
    local highest=$(get_highest_from_specs "$specs_dir")
    if [ "$has_git_repo" = true ]; then
        git fetch --all --prune 2>/dev/null || true
        local highest_branch=$(get_highest_from_branches)
        [ "$highest_branch" -gt "$highest" ] && highest=$highest_branch
    fi
    echo $((highest + 1))
}

build_branch_name() {
    local feature_num="$1"
    local suffix="$2"
    local name="${feature_num}-${suffix}"
    local max_length=244
    if [ ${#name} -gt $max_length ]; then
        local max_suffix=$((max_length - 4))
        local truncated=$(printf '%s' "$suffix" | cut -c1-$max_suffix | sed 's/-$//')
        name="${feature_num}-${truncated}"
        >&2 echo "[specify] Warning: Branch name truncated to $max_length bytes"
    fi
    printf '%s\n' "$name"
}
