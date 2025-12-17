# Commit Changes

Create a git commit for staged or all changes in the current repository.

## Instructions

1. **Check current status** - Run `git status` and `git diff --stat` to see what will be committed

2. **Check recent commits** - Run `git log --oneline -5` to understand commit message style in this repo

3. **Analyze changes** - Look at the diff to understand what was changed and why

4. **Stage files if needed** - If there are unstaged changes the user wants to commit, stage them with `git add`

5. **Create commit message** following this repo's conventions:
   - Use conventional commits format: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`, etc.
   - First line: concise summary (50 chars or less ideal)
   - Blank line, then bullet points explaining key changes
   - No signature or co-author attribution (private project)

6. **Commit format**:
```bash
git commit -m "$(cat <<'EOF'
<type>: <short summary>

- <bullet point 1>
- <bullet point 2>
EOF
)"
```

7. **Verify** - Run `git status` and `git log --oneline -1` to confirm

## Commit Types

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `refactor` | Code change that neither fixes nor adds |
| `chore` | Maintenance, deps, config |
| `style` | Formatting, whitespace |
| `test` | Adding/updating tests |

## Important

- Do NOT commit `.env` files or secrets
- Do NOT use `--force` or destructive commands
- Do NOT add Claude Code signature or Co-Authored-By (private project)
- Ask user if unsure what to include in the commit
