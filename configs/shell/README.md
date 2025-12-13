# Shell

Shell UI components: help system and welcome message.

## Files

- `help.zsh` - Help commands and tips
- `welcome.zsh` - Welcome message on shell startup

## Commands

### `config-help`
Display overview of all aliases and commands.

```zsh
config-help
```

Output includes:
- Git aliases
- PHP & Laravel aliases
- Tool aliases
- Utility functions
- Cache management

### `tips`
Display random tips (5 tips).

```zsh
tips
```

Includes time-based greetings and tips based on installed tools.

## Welcome Message

On shell startup, displays:
1. Professional intro banner
2. 5 random tips
3. External tools warning (if using system tools instead of binary-files)

## Customization

### Disable welcome message
Comment out the welcome.zsh source line in `config.zsh`:

```zsh
# "$CONFIG_DIR/shell/welcome.zsh"
```

### Modify intro
Edit `_show_intro()` function in `welcome.zsh`.
