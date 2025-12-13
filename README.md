# Development Utilities

Repository ini berisi konfigurasi dan tools untuk mendukung development lokal di macOS.

## Kenapa Repo Ini Ada?

**Capek install sana-sini, eh pas mau hapus malah ribet.**

Kita semua pernah mengalami:
- Install tool A, ternyata butuh dependency B, C, D
- Setahun kemudian mau uninstall, eh "package X is required by Y, Z, ..."
- Homebrew packages yang numpuk kayak koleksi action figure yang lupa pernah beli
- `/usr/local/bin` yang isinya udah kayak gudang rongsok

**Solusinya?** Filosofi yang simple:

1. **Binary standalone** - Download, taruh di folder, selesai. Mau hapus? Delete file. Done.
2. **Docker untuk services** - Database, cache, storage? Containerized. `docker compose down && docker volume rm` = bersih tanpa bekas.
3. **Config yang portable** - Satu source file, semua setup jalan. Pindah laptop? Copy folder, source, profit.

Intinya: **Install cepat, hapus lebih cepat, nggak ada drama dependency.**

## Struktur

```
.
├── binary-files/              # Binary tools standalone
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
- [MongoDB](docker-compose-setting/mongodb/README.md) - NoSQL document database
- [PostgreSQL](docker-compose-setting/postgresql/README.md) - Relational database

```bash
# Contoh menjalankan DragonflyDB
cd docker-compose-setting/dragonfly
cp .env.example .env
docker compose up -d
```
