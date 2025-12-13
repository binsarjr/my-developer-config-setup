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
- `alias-finder` / `af` - fzf search through all aliases
- `cache-cleanup` - Interactive cache cleanup (brew, npm, composer, docker, etc.)
- `project-cleanup` - Remove node_modules, vendor, __pycache__ from projects

**Alias Registration:**
```zsh
_reg "alias" "command" "description" "tags"
```
Tags (comma-separated) make aliases discoverable via `alias-finder` search.

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

**Recommended:** fzf, rg, fd, bat, lsd, lazygit, lazydocker, delta, starship, zoxide, dust, duf, btm, jq, fx, gron

Run `config-doctor` to check which tools are installed.

## Environment Files

Each Docker service has `.env.example`. Copy to `.env` before running. All `.env` files are gitignored.

## Language

Always use **English** for all documentation, comments, commit messages, and code in this repository.
