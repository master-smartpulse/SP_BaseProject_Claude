#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write): formats the edited file with Prettier
# when the derived project has it configured. No-op otherwise (fail-open).

input=$(cat)
file=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

case "$file" in
    *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss)
        if command -v npx >/dev/null 2>&1 && [ -f package.json ] && grep -q '"prettier"' package.json 2>/dev/null; then
            npx prettier --write "$file" >/dev/null 2>&1 || true
        fi
        ;;
esac

exit 0
