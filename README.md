# Development Utilities

A macOS development utilities repository with modular shell configuration, Docker Compose services, and standalone binary tool management.

## Why This Repo?

**Tired of install here, install there, then struggle to remove.**

We've all been there:
- Install tool A, turns out it needs dependency B, C, D
- A year later want to uninstall, "package X is required by Y, Z, ..."
- Homebrew packages piling up like forgotten action figures
- `/usr/local/bin` looking like a junkyard

**The solution?** A simple philosophy:

1. **Standalone binaries** - Download, put in folder, done. Want to remove? Delete file. Done.
2. **Docker for services** - Database, cache, storage? Containerized. `docker compose down && docker volume rm` = clean without trace.
3. **Portable config** - One source file, everything works. New laptop? Copy folder, source, profit.

Bottom line: **Install fast, remove faster, no dependency drama.**

## Usage

### Option 1: Direct Clone (use as-is)

If you want to use all my configurations without modification:

```bash
git clone https://github.com/binsarjr/my-developer-config-setup.git ~/Developers
```

### Option 2: Fork (for customization)

If you want to customize it to your own style and needs, **fork this repo** then clone from your fork:

```bash
git clone https://github.com/USERNAME/my-developer-config-setup.git ~/Developers
```

> **Note:** This is my personal configuration tailored to my own workflow. I don't accept PRs for changing preferences/style. However, with a fork you can still get the latest updates by syncing your fork from this repo.

#### Sync Fork with Upstream

```bash
git remote add upstream https://github.com/binsarjr/my-developer-config-setup.git
git fetch upstream
git merge upstream/main
```

## Structure

```
.
├── binary-files/              # Standalone binary tools
├── configs/                   # Modular shell configuration
│   ├── config.zsh             # Entry point
│   ├── starship.toml          # Prompt config
│   ├── install-helper         # Binary download guide
│   ├── project-cleanup        # Cleanup tool
│   ├── core/                  # Alias registry
│   ├── tools/                 # CLI tool configs
│   ├── git/                   # Git aliases
│   ├── php/                   # PHP & Laravel
│   ├── bun/                   # Bun runtime
│   ├── utils/                 # Utility functions
│   ├── shell/                 # Help & welcome
│   └── maintenance/           # Cache cleanup
├── docker-compose-setting/
│   ├── dragonfly/             # Redis-compatible in-memory database
│   ├── minio/                 # S3-compatible object storage
│   ├── mongodb/               # NoSQL document database
│   └── postgresql/            # Relational database
└── CLAUDE.md                  # AI assistant guidance
```

## Quick Start

### Shell Configuration

Add to `~/.zshrc`:

```bash
source "$HOME/Developers/configs/config.zsh"
```

This will automatically setup PATH, aliases, and tool configurations. See [configs/README.md](configs/README.md) for details.

### Binary Tools

Run `install-helper` to see download guide for binaries matching your Mac architecture. See [binary-files/README.md](binary-files/README.md).

### Docker Services

Each service has complete documentation in its folder:

- [DragonflyDB](docker-compose-setting/dragonfly/README.md) - In-memory database (Redis replacement)
- [MinIO](docker-compose-setting/minio/README.md) - Object storage (S3 replacement)
- [MongoDB](docker-compose-setting/mongodb/README.md) - NoSQL document database
- [PostgreSQL](docker-compose-setting/postgresql/README.md) - Relational database

```bash
# Example: running DragonflyDB
cd docker-compose-setting/dragonfly
cp .env.example .env
docker compose up -d
```
