# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

A macOS development utilities repository with Docker Compose services, modular shell configuration, and standalone binary tool management. Philosophy: "Install fast, remove faster, no dependency drama."

## Architecture

```
├── configs/                    # Modular shell configuration
│   ├── config.zsh              # Entry point (sources all modules)
│   ├── starship.toml           # Prompt configuration
│   ├── install-helper          # Binary download guide script
│   ├── project-cleanup         # Dependency cleanup tool
│   ├── core/                   # Alias registry system
│   ├── tools/                  # Modern CLI tool configs
│   ├── git/                    # Git aliases
│   ├── php/                    # PHP/Laravel aliases + version manager
│   ├── bun/                    # Bun runtime aliases
│   ├── utils/                  # Utility functions
│   ├── shell/                  # Help system + welcome banner
│   └── maintenance/            # Cache cleanup utilities
├── cheatsheets/                # Project cheatsheets (versioned)
│   ├── docker.txt              # Docker/Lima commands
│   ├── php.txt                 # PHP manager commands
│   ├── rsync.txt               # Rsync utilities
│   └── utils.txt               # Utility functions
├── docker-compose-setting/     # Docker services
│   ├── dragonfly/              # Redis-compatible (port 6379)
│   ├── minio/                  # S3-compatible (API: 9000, Console: 9001)
│   ├── mongodb/                # NoSQL (port 27017)
│   └── postgresql/             # SQL (port 5432)
└── binary-files/               # Standalone binaries (gitignored)
```

## Shell Configuration

**Setup:** Add to `~/.zshrc`:
```bash
source "$HOME/Developers/configs/config.zsh"
```

**Module Loading Order:** config.zsh auto-detects paths and sources modules: core → tools → git → php → bun → utils → shell → maintenance

**Key Commands:**
- `config-help` - Show all available aliases by category
- `config-doctor` - Check installation status of recommended tools
- `tips` - Display random tips
- `cheat` - fzf search through all commands (cheatsheet)
- `cache-cleanup` - Interactive cache cleanup (brew, npm, composer, docker, etc.)
- `project-cleanup` - Remove node_modules, vendor, __pycache__ from projects

**Alias Registration:**
```zsh
_reg "alias" "command" "description" "tags"
```
Tags (comma-separated) make aliases discoverable via `cheat` search.

## Design Principles

**SSOT (Single Source of Truth):** All alias data lives in `ALIAS_REGISTRY`. This feeds:
- `tips` command
- `cheat` (searchable cheatsheet)
- Welcome message tips
- `alias-list`

When adding new aliases, use `_reg` - they automatically appear everywhere.

**DRY (Don't Repeat Yourself):** Avoid hardcoding the same data in multiple places. If you need alias/command info, read from `ALIAS_REGISTRY` instead of maintaining separate lists.

## Cheatsheets

The `cheat` command provides an interactive fzf-based search across all commands.

**Locations:**
- Project: `cheatsheets/` (versioned, shared)
- Personal: `~/.config/cheatsheets/` (user overrides, not tracked)

**File Format:**
```
# command-name
Description of what the command does
actual-command <args>
---
```

Each entry has: name (after `#`), description (next line), command (following lines), separator (`---`).

**Adding Commands:**
- Aliases: Use `_reg` in module files (auto-discovered)
- Functions: Add to `cheatsheets/*.txt` with the format above

## Docker Services

**Quick Start Pattern:**
```bash
cd docker-compose-setting/<service>
cp .env.example .env && nano .env
docker compose up -d
```

| Service | Ports | Key Env Vars |
|---------|-------|--------------|
| dragonfly | 6379 | DRAGONFLY_PASSWORD, DRAGONFLY_MAXMEMORY |
| minio | 9000/9001 | MINIO_ROOT_USER, MINIO_ROOT_PASSWORD, MINIO_BUCKET |
| mongodb | 27017 | MONGO_ROOT_USER, MONGO_ROOT_PASSWORD, MONGO_DATABASE |
| postgresql | 5432 | POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB |

## Docker with Lima

Lima-based Docker setup (alternative to Docker Desktop/OrbStack).

**Commands:**
- `docker-install` - Auto install Lima + Docker + docker-compose
- `docker-uninstall` - Remove Lima + Docker
- `docker-start` / `docker-stop` / `docker-restart` - VM control
- `docker-status` - Show Lima VM status
- `docker-prune [-a]` - Clean up unused resources

## Binary Tools

Located in `binary-files/`. Only `.gitkeep` and `README.md` are tracked; binaries are architecture-specific.

**Install new tools:**
1. Download from GitHub releases (use `install-helper` for links)
2. Extract and move to `binary-files/`
3. `chmod +x <binary>`

**Recommended:** fzf, rg, fd, bat, lsd, lazygit, lazydocker, delta, starship, zoxide, dust, duf, btm, jq, fx, gron, curlie

Run `config-doctor` to check which tools are installed.

## Environment Files

Each Docker service has `.env.example`. Copy to `.env` before running. All `.env` files are gitignored.

## Language

Always use **English** for all documentation, comments, commit messages, and code in this repository.

## Claude Code Status Line

**File:** `statusline-command.sh`

A comprehensive status line script for Claude Code that displays real-time session information.

### Setup (Portable)

Uses a **symlink approach** so the repo can be placed anywhere:

1. **Run `/setup-statusline`** - Creates symlink and configures settings
2. **Symlink location:** `~/.config/claude-code/statusline-command.sh` → repo's `statusline-command.sh`
3. **If repo is moved:** Re-run `/setup-statusline` to update the symlink

### Components

| Component | Description | Colors |
|-----------|-------------|--------|
| Model | Claude model name | Magenta=Opus, Blue=Sonnet, Green=Haiku |
| Think Mode | THINK/no-think | Cyan/Dim |
| Output Style | Current style (if not default) | Cyan |
| Directory | Git-aware path | Bright Cyan |
| Git Branch | Branch + status indicators | Magenta + Yellow/Red/Green |
| Lines Changed | +added/-removed | Green/Red |
| Tokens | in:XXK out:XXK | Blue/Green |
| Cost | $X.XXXX | Green/<$0.1, Yellow/$0.1-1, Red/>$1 |
| Duration | Session time | Cyan |
| Context % | Usage percentage | Green/Yellow/Red by level |
| Version | Claude Code version | Dim |
| Session ID | First 8 chars | Dim |

### Git Status Indicators
- `*` = Uncommitted changes (yellow)
- `?` = Untracked files (red)
- `+` = Staged changes (green)
- `↑N` = Commits ahead (green)
- `↓N` = Commits behind (red)

### Custom Command

**`/setup-statusline`** - Creates symlink and configures Claude Code to use the status line.

### Manual Configuration

1. Create symlink:
```bash
mkdir -p ~/.config/claude-code
ln -sf /path/to/repo/statusline-command.sh ~/.config/claude-code/statusline-command.sh
```

2. Add to `~/.claude/settings.json`:
```json
{
  "statusLine": {
    "type": "command",
    "command": "/bin/bash -c 'bash ~/.config/claude-code/statusline-command.sh'"
  }
}
```

### Customizing

Edit `statusline-command.sh` in the repo to customize colors, format, or information displayed. Restart Claude Code after changes.
