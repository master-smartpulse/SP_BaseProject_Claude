#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash): blocks git commit/push while on the main branch.
# Matches git at a command position (start or after ; & | && ||), tolerating global
# flags such as -C <dir>, -c <k=v> and --long-options between "git" and the verb —
# so quoted strings mentioning "git commit" no longer false-positive, and
# "git -c ... commit" no longer bypasses the guard.
# Fail-open by design: any parsing issue lets the command through.

input=$(cat)
command=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")
[ -n "$command" ] || exit 0

GIT_VERB_RE='(^|[;&|][[:space:]]*)git([[:space:]]+(-C[[:space:]]*[^[:space:]]+|-c[[:space:]]*[^[:space:]]+|--[^[:space:]]+))*[[:space:]]+(commit|push)([[:space:]]|$)'

if printf '%s' "$command" | grep -qE "$GIT_VERB_RE"; then
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
    if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
        echo "Blocked: git commit/push directly on '$branch'. Create a feature branch first (/specify or /specify-tech)." >&2
        exit 2
    fi
fi

exit 0
