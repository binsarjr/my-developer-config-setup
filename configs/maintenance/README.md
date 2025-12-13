# Maintenance

Cache cleanup dan maintenance tools.

## Files

- `cache-cleanup.zsh` - Interactive cache cleanup

## Commands

### `cache-cleanup`
Interactive cache cleanup dengan fzf multi-select.

```zsh
cache-cleanup       # Verbose mode (default)
cache-cleanup -q    # Quick mode (clean all, minimal output)
```

**Supported caches:**
- Homebrew (`brew cleanup`)
- Composer (`composer clear-cache`)
- npm (`npm cache clean --force`)
- pip (`pip3 cache purge`)
- Docker (`docker system prune -f`)

**Features:**
- fzf multi-select (Tab to select multiple)
- Fallback to Y/n prompt if fzf not installed
- Shows project-cleanup tip after completion

### `cache-help`
Show individual cache cleanup commands.

```zsh
cache-help
```

## Reminder

On shell startup, shows reminder:
```
🧹 Run cache-cleanup to clean caches | cache-help for commands
```

## Project Cleanup

For cleaning project dependencies (node_modules, vendor, __pycache__):

```zsh
project-cleanup ~/Projects       # Scan & clean
project-cleanup -n ~/Projects    # Dry run (preview)
```

## Dependencies

- fzf (optional, for interactive multi-select)
- Tools are auto-detected (only shows installed ones)
