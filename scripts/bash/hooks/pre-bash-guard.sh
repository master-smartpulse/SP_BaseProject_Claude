#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash): blocks git commit/push while on the main branch.
# Fail-open by design: any parsing issue lets the command through.

input=$(cat)
command=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('command',''))" 2>/dev/null || echo "")

case "$command" in
    *"git commit"*|*"git push"*)
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
        if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
            echo "Blocked: git commit/push directly on '$branch'. Create a feature branch first (/specify or /specify-tech)." >&2
            exit 2
        fi
        ;;
esac

exit 0
