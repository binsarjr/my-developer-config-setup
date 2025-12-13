# Core

Core functions used by other modules.

## Files

- `alias-registry.zsh` - Alias registry + cheat (cheatshh-like)

## Functions

### `_reg <name> <command> <description> [tags]`
Register alias with description and tags. Used by all modules.

```zsh
_reg gs "git status" "Show Git working tree status" "git,status"
```

## Commands

| Command | Description |
|---------|-------------|
| `cheat` | Interactive cheatsheet (aliases + custom) |
| `cheat -g` | Browse by group/tag first |
| `cheat -a` | Add custom cheatsheet entry |
| `cheat -e` | Edit custom cheatsheets |
| `alias-list` | Show all registered aliases |

## Cheat - Interactive Cheatsheet

Full cheatshh-like experience without external dependencies.

### Basic Usage

```zsh
cheat              # Search all (aliases + custom)
cheat docker       # Search for 'docker'
cheat -g           # Browse by group first
cheat -a           # Add new custom entry
cheat -e           # Edit cheatsheets
cheat -e docker    # Edit docker cheatsheet directly
```

### Key Bindings (in fzf)

| Key | Action |
|-----|--------|
| Enter | Select and show info + put in buffer |
| Ctrl-T | View tldr page (if installed) |
| Ctrl-M | View man page |

### Search Syntax

| Pattern | Meaning |
|---------|---------|
| `'word` | Exact match |
| `^word` | Starts with |
| `word$` | Ends with |
| `!word` | Exclude |

### Custom Cheatsheets

Stored in `~/.config/cheatsheets/*.txt`. File name = group name.

**Format:**
```
# command-name
Description here
actual command or multiline note
---
# another-command
Another description
another command
---
```

**Example** (`~/.config/cheatsheets/docker.txt`):
```
# docker-clean-all
Remove all containers, images, volumes
docker system prune -a --volumes
---
# docker-logs-tail
Follow container logs with timestamps
docker logs -f --timestamps container_name
---
```

### Architecture

```
ALIAS_REGISTRY          CUSTOM_CHEATSHEETS
(aliases, tips)         (~/.config/cheatsheets/)
        │                       │
        └───────┬───────────────┘
                │
            cheat()
```

- **ALIAS_REGISTRY**: Used by `tips`, `alias-list`, and `cheat`
- **CUSTOM_CHEATSHEETS**: Only used by `cheat` (separate storage)
