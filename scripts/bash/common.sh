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
        echo "Hint: export SPECIFY_FEATURE=001-feature-name to target a feature outside a feature branch (e.g. detached HEAD or main)" >&2
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

    # Features created via /specify-tech have spec-tech.md instead of spec.md;
    # FEATURE_SPEC points to whichever exists.
    local feature_spec="$feature_dir/spec.md"
    if [[ ! -f "$feature_spec" && -f "$feature_dir/spec-tech.md" ]]; then
        feature_spec="$feature_dir/spec-tech.md"
    fi

    # printf %q keeps the output safe to eval even if paths contain quotes or spaces
    printf 'REPO_ROOT=%q\n' "$repo_root"
    printf 'CURRENT_BRANCH=%q\n' "$current_branch"
    printf 'HAS_GIT=%q\n' "$has_git_repo"
    printf 'FEATURE_DIR=%q\n' "$feature_dir"
    printf 'FEATURE_SPEC=%q\n' "$feature_spec"
    printf 'SPEC_TECH=%q\n' "$feature_dir/spec-tech.md"
    printf 'IMPL_PLAN=%q\n' "$feature_dir/plan.md"
    printf 'TASKS=%q\n' "$feature_dir/tasks.md"
    printf 'RESEARCH=%q\n' "$feature_dir/research.md"
    printf 'DATA_MODEL=%q\n' "$feature_dir/data-model.md"
    printf 'QUICKSTART=%q\n' "$feature_dir/quickstart.md"
    printf 'CONTRACTS_DIR=%q\n' "$feature_dir/contracts"
}

check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

# Escapes backslashes and double quotes for safe interpolation into JSON strings
json_escape() {
    printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# Serializes its arguments as a JSON array of escaped strings
json_array() {
    if [ $# -eq 0 ]; then
        printf '[]'
        return
    fi
    local result=""
    local item
    for item in "$@"; do
        result="$result\"$(json_escape "$item")\","
    done
    printf '[%s]' "${result%,}"
}

# --- Functions shared by the creation scripts (specify / specify-tech) ---

# Parses the flags shared by the creation scripts into globals:
# JSON_MODE, SHORT_NAME, BRANCH_NUMBER, UPDATE_MODE and ARGS (remaining words).
parse_create_args() {
    JSON_MODE=false
    SHORT_NAME=""
    BRANCH_NUMBER=""
    UPDATE_MODE=false
    ARGS=()
    while [ $# -gt 0 ]; do
        case "$1" in
            --json) JSON_MODE=true ;;
            --update) UPDATE_MODE=true ;;
            --short-name)
                if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
                    echo 'Error: --short-name requires a value' >&2
                    exit 1
                fi
                SHORT_NAME="$2"
                shift
                ;;
            --number)
                if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
                    echo 'Error: --number requires a value' >&2
                    exit 1
                fi
                case "$2" in
                    ''|*[!0-9]*)
                        echo 'Error: --number requires a numeric value' >&2
                        exit 1
                        ;;
                esac
                BRANCH_NUMBER="$2"
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [--json] [--update] [--short-name NAME] [--number N] DESCRIPTION"
                echo "  --json       Output in JSON format"
                echo "  --update     Reuse the current feature branch/dir instead of creating a new one"
                echo "  --short-name Custom short name for the branch"
                echo "  --number N   Specify branch number manually"
                exit 0
                ;;
            *)
                ARGS+=("$1")
                ;;
        esac
        shift
    done
}

# Resolves the base ref for new feature branches: main > master > current HEAD.
default_base_ref() {
    if git rev-parse --verify main >/dev/null 2>&1; then
        echo "main"
    elif git rev-parse --verify master >/dev/null 2>&1; then
        echo "master"
    else
        echo ""
    fi
}

# Creates the feature branch (when git is available), the feature directory and
# the initial spec file from a template, then prints the result (JSON or text).
# New branches start from main/master when available (not from the current branch).
# SPECIFY_PUSH=1 publishes the branch upstream so other devs' numbering sees it.
# Args: branch_name feature_num template_path spec_filename json_mode
create_feature_scaffold() {
    local branch_name="$1"
    local feature_num="$2"
    local template="$3"
    local spec_filename="$4"
    local json_mode="$5"

    if has_git; then
        local base_ref
        base_ref=$(default_base_ref)
        if [ -n "$base_ref" ] && git checkout -b "$branch_name" "$base_ref" 2>/dev/null; then
            :
        else
            [ -n "$base_ref" ] && >&2 echo "[specify] Warning: could not branch from '$base_ref' (uncommitted changes?); branching from current HEAD"
            git checkout -b "$branch_name"
        fi
        if [ "${SPECIFY_PUSH:-0}" = "1" ]; then
            git push -u origin "$branch_name" 2>/dev/null || \
                >&2 echo "[specify] Warning: could not push branch to origin (offline or no remote)"
        fi
    else
        >&2 echo "[specify] Warning: Git not detected; skipped branch creation"
    fi

    local repo_root
    repo_root=$(get_repo_root)
    local feature_dir="$repo_root/specs/$branch_name"
    mkdir -p "$feature_dir"

    local spec_file="$feature_dir/$spec_filename"
    if [ -f "$template" ]; then
        cp "$template" "$spec_file"
    else
        touch "$spec_file"
    fi

    if [ "$json_mode" = true ]; then
        printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s"}\n' \
            "$(json_escape "$branch_name")" "$(json_escape "$spec_file")" "$(json_escape "$feature_num")"
    else
        echo "BRANCH_NAME: $branch_name"
        echo "SPEC_FILE: $spec_file"
        echo "FEATURE_NUM: $feature_num"
    fi
}

# Resolves a UTF-8 locale for multibyte-aware sed/iconv: keeps the current one
# when already UTF-8, otherwise picks C.UTF-8/en_US.UTF-8 when available.
utf8_locale() {
    case "${LC_ALL:-${LANG:-}}" in
        *[Uu][Tt][Ff]*) printf '%s' "${LC_ALL:-$LANG}"; return ;;
    esac
    locale -a 2>/dev/null | grep -im1 '^C\.UTF' || locale -a 2>/dev/null | grep -im1 '^en_US\.UTF' || printf 'C'
}

# Converts accented characters to ASCII (e.g. "autenticação" -> "autenticacao").
# Primary path: sed table covering pt-BR diacritics (multibyte y/// requires a
# UTF-8 locale — forced via utf8_locale so C-locale CI runners still work).
# Fallback: iconv //TRANSLIT for anything else (exit code ignored — macOS iconv
# exits non-zero on inexact conversions while still producing output), then strips
# transliteration artifacts some iconv implementations emit (~ ^ ` ' " , ?).
transliterate() {
    local input="$1"
    local loc
    loc=$(utf8_locale)
    local result
    result=$(printf '%s' "$input" | LC_ALL="$loc" sed 'y/áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ/aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN/' 2>/dev/null) || result=""
    [ -n "$result" ] || result="$input"
    local converted
    converted=$(printf '%s' "$result" | LC_ALL="$loc" iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null || true)
    [ -n "$converted" ] || converted="$result"
    printf '%s' "$converted" | sed "s/[~^\`'\",?]//g"
}

# Reuses the current feature branch/dir instead of creating a new one (--update).
# Creates the spec from the template only when missing; never overwrites.
# Args: template_path spec_filename json_mode
reuse_feature_scaffold() {
    local template="$1"
    local spec_filename="$2"
    local json_mode="$3"

    eval "$(get_feature_paths)"
    if [[ ! "$CURRENT_BRANCH" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: --update requires a feature branch (or SPECIFY_FEATURE set). Current branch: $CURRENT_BRANCH" >&2
        exit 1
    fi
    mkdir -p "$FEATURE_DIR"
    local spec_file="$FEATURE_DIR/$spec_filename"
    if [ ! -f "$spec_file" ]; then
        if [ -f "$template" ]; then
            cp "$template" "$spec_file"
        else
            touch "$spec_file"
        fi
    fi
    local feature_num="${CURRENT_BRANCH:0:3}"
    if [ "$json_mode" = true ]; then
        printf '{"BRANCH_NAME":"%s","SPEC_FILE":"%s","FEATURE_NUM":"%s","UPDATED":"true"}\n' \
            "$(json_escape "$CURRENT_BRANCH")" "$(json_escape "$spec_file")" "$(json_escape "$feature_num")"
    else
        echo "BRANCH_NAME: $CURRENT_BRANCH"
        echo "SPEC_FILE: $spec_file"
        echo "FEATURE_NUM: $feature_num"
        echo "UPDATED: true"
    fi
}

clean_branch_name() {
    transliterate "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//'
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
        # Network refresh is opt-in (SPECIFY_FETCH=1) so numbering never blocks on connectivity;
        # without it, numbering uses specs/ plus local and previously fetched branches.
        if [ "${SPECIFY_FETCH:-0}" = "1" ]; then
            git fetch --all --prune 2>/dev/null || true
        fi
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
