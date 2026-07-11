#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write): formats the edited file with Prettier
# when the derived project has it configured. No-op otherwise (fail-open).
# Resolves the project root via $CLAUDE_PROJECT_DIR so it works regardless of cwd.

input=$(cat)
file=$(printf '%s' "$input" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")
[ -n "$file" ] || exit 0
[ -f "$file" ] || exit 0

project_root="${CLAUDE_PROJECT_DIR:-.}"

case "$file" in
    *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss)
        if command -v npx >/dev/null 2>&1 && [ -f "$project_root/package.json" ] && grep -q '"prettier"' "$project_root/package.json" 2>/dev/null; then
            (cd "$project_root" && npx prettier --write "$file" >/dev/null 2>&1) || true
        fi
        ;;
esac

exit 0
