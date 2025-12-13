# Configs

Modular shell configuration for development environment.

## Usage

### Option 1: Direct Clone (use as-is)

If you want to use all my configurations without modification:

```bash
git clone https://github.com/binsarjr/my-developer-config-setup.git ~/Developers/configs
```

### Option 2: Fork (for customization)

If you want to customize it to your own style and needs, **fork this repo** then clone from your fork:

```bash
git clone https://github.com/USERNAME/my-developer-config-setup.git ~/Developers/configs
```

> **Note:** This is my personal configuration tailored to my own workflow. I don't accept PRs for changing preferences/style. However, with a fork you can still get the latest updates by syncing your fork from this repo.

#### Sync Fork with Upstream

```bash
git remote add upstream https://github.com/binsarjr/my-developer-config-setup.git
git fetch upstream
git merge upstream/main
```

## Setup

Add this line to your `~/.zshrc`:

```bash
source "$HOME/Developers/configs/config.zsh"
```

## Structure

| Module | Description |
|--------|-------------|
| [core/](core/) | Alias registry system (`_reg`, `alias-finder`) |
| [tools/](tools/) | Modern CLI tools (lsd, bat, lazygit, zoxide, fzf, delta) |
| [git/](git/) | Git aliases & quick combos (gac, wip, nah) |
| [php/](php/) | PHP & Laravel aliases + version manager |
| [bun/](bun/) | Bun runtime & package manager aliases |
| [utils/](utils/) | Utility functions (mkcd, backup, extract, ports) |
| [shell/](shell/) | Help system & welcome message |
| [maintenance/](maintenance/) | Cache cleanup utilities |

## Key Files

| File | Description |
|------|-------------|
| `config.zsh` | Entry point - auto-detect paths, sources all modules |
| `starship.toml` | Starship prompt configuration |
| `install-helper` | Script to view binary tools download guide |
| `project-cleanup` | Script to cleanup node_modules, vendor, __pycache__ |

## Auto Configuration

`config.zsh` will automatically:
- Add `binary-files/` and `configs/` to PATH
- Detect installed tools (in binary-files or system)
- Apply configuration/aliases if tool is available
- Load modules in order: core → tools → git → php → bun → utils → shell → maintenance

## Project Cleanup

`project-cleanup` removes large folders that can be regenerated:
- `node_modules` (Node.js/npm/yarn)
- `vendor` (PHP/Composer - only if composer.json exists)
- `__pycache__` (Python)

### Usage

```bash
project-cleanup              # cleanup current directory
project-cleanup ~/Projects   # cleanup specific directory
project-cleanup -n           # dry run (preview only)
project-cleanup --help       # show help
```

### Output Example

```
Scanning: /Users/you/Projects
(Dry run - nothing will be deleted)

node_modules:
  [DRY] /Users/you/Projects/app1/node_modules (245M)
  [DRY] /Users/you/Projects/app2/node_modules (189M)

vendor (PHP/Composer):
  [DRY] /Users/you/Projects/laravel-app/vendor (87M)

__pycache__ (Python):
  (none found)

Would free: ~521M
```

## Customization

### Starship Prompt

Edit `starship.toml` to customize prompt. Documentation: https://starship.rs/config/

### Aliases

Add custom aliases in `config.zsh` or create a separate file and source it from config.zsh.
