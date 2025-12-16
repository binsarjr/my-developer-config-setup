# Setup Claude Code Status Line

Configure Claude Code to use the custom status line script from this repository.

## Setup Strategy

Use a **symlink approach** for portability:
1. Create symlink at `~/.config/claude-code/statusline-command.sh` → actual script location
2. Settings.json points to the fixed symlink path
3. If user moves the repo, just re-run `/setup-statusline` to update the symlink

## Instructions

1. **Find the script location** - Look for `statusline-command.sh` in the current project root (where CLAUDE.md is located)

2. **Create the symlink directory and symlink**:
   ```bash
   mkdir -p ~/.config/claude-code
   ln -sf /path/to/repo/statusline-command.sh ~/.config/claude-code/statusline-command.sh
   ```

3. **Update `~/.claude/settings.json`** with the fixed symlink path:
   ```json
   {
     "statusLine": {
       "type": "command",
       "command": "/bin/bash ~/.config/claude-code/statusline-command.sh"
     }
   }
   ```

4. **Preserve existing settings** - Read settings.json first and only add/update the `statusLine` section

5. **Inform user** to restart Claude Code after the change

## Status Line Features

The status line displays:
- **Model**: Opus (magenta), Sonnet (blue), Haiku (green)
- **Think Mode**: THINK/no-think (from settings.json)
- **Output Style**: If not default
- **Directory**: Git-aware path shortening
- **Git Branch**: With status indicators (* ? + ↑↓)
- **Lines Changed**: +added/-removed
- **Tokens**: in:XXK out:XXK (cumulative)
- **Cost**: $X.XXXX (color-coded by amount)
- **Duration**: Session time (⏱ Xm Xs)
- **Context %**: Color-coded usage warning
- **Version**: Claude Code version
- **Session ID**: First 8 characters

## Portability

- **Fixed path in settings.json**: `~/.config/claude-code/statusline-command.sh`
- **Actual script**: Lives in the repo (wherever user clones it)
- **Re-run setup**: If repo is moved, run `/setup-statusline` again to update the symlink
