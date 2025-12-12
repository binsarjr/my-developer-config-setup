# Development Utilities

Repository ini berisi konfigurasi dan tools untuk mendukung development lokal di macOS.

## Struktur

```
.
├── binary-files/          # Binary tools standalone
├── configs/               # Shell configuration files
│   ├── config.zsh
│   ├── starship.toml
│   └── install-helper
├── docker-compose-setting/
│   ├── dragonfly/         # Redis-compatible in-memory database
│   └── minio/             # S3-compatible object storage
└── CLAUDE.md              # AI assistant guidance
```

## Quick Start

### Shell Configuration

Tambahkan ke `~/.zshrc`:

```bash
source "$HOME/Developers/configs/config.zsh"
```

Ini akan otomatis setup PATH, aliases, dan tool configurations. Lihat [configs/README.md](configs/README.md) untuk detail.

### Binary Tools

Jalankan `install-helper` untuk melihat panduan download binary sesuai arsitektur Mac. Lihat [binary-files/README.md](binary-files/README.md).

### Docker Services

Setiap service memiliki dokumentasi lengkap di folder masing-masing:

- [DragonflyDB](docker-compose-setting/dragonfly/README.md) - In-memory database (Redis replacement)
- [MinIO](docker-compose-setting/minio/README.md) - Object storage (S3 replacement)

```bash
# Contoh menjalankan DragonflyDB
cd docker-compose-setting/dragonfly
cp .env.example .env
docker compose up -d
```
