# Core

Core functions used by other modules.

## Files

- `alias-registry.zsh` - Alias registry system with descriptions

## Functions

### `_reg <name> <command> <description>`
Register alias with description. Used by all modules to define aliases.

```zsh
_reg gs "git status" "Show Git working tree status"
```

## Commands

| Command | Description |
|---------|-------------|
| `cheat` | Search aliases & commands with fzf (cheatsheet) |
| `alias-list` | Show all registered aliases |

## Usage

```zsh
# Search commands (cheatsheet)
cheat
cheat git     # filter by 'git'

# List all aliases
alias-list
```
