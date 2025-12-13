# Configs

Modular shell configuration untuk development environment.

## Cara Menggunakan

### Opsi 1: Clone langsung (untuk yang ingin pakai as-is)

Jika kamu ingin menggunakan semua konfigurasi saya tanpa modifikasi:

```bash
git clone https://github.com/binsarjr/my-developer-config-setup.git ~/Developers/configs
```

### Opsi 2: Fork (untuk yang ingin customize)

Jika kamu ingin menyesuaikan dengan style dan kebutuhan sendiri, **fork repo ini** kemudian clone dari fork kamu:

```bash
git clone https://github.com/USERNAME/my-developer-config-setup.git ~/Developers/configs
```

> **Note:** Konfigurasi ini adalah setup personal saya dan disesuaikan dengan workflow saya sendiri. Saya tidak menerima PR untuk mengubah preferensi/style. Namun dengan fork, kamu tetap bisa mendapatkan update terbaru dengan cara sync fork dari repo ini.

#### Sync Fork dengan Upstream

```bash
git remote add upstream https://github.com/binsarjr/my-developer-config-setup.git
git fetch upstream
git merge upstream/main
```

## Setup

Tambahkan satu baris ini ke `~/.zshrc`:

```bash
source "$HOME/Developers/configs/config.zsh"
```

## Structure

| Module | Deskripsi |
|--------|-----------|
| [core/](core/) | Alias registry system (`_reg`, `alias-finder`) |
| [tools/](tools/) | Modern CLI tools (lsd, bat, lazygit, zoxide, fzf, delta) |
| [git/](git/) | Git aliases & quick combos (gac, wip, nah) |
| [php/](php/) | PHP & Laravel aliases + version manager |
| [bun/](bun/) | Bun runtime & package manager aliases |
| [utils/](utils/) | Utility functions (mkcd, backup, extract, ports) |
| [shell/](shell/) | Help system & welcome message |
| [maintenance/](maintenance/) | Cache cleanup utilities |

## Key Files

| File | Deskripsi |
|------|-----------|
| `config.zsh` | Entry point - auto-detect paths, sources all modules |
| `starship.toml` | Starship prompt configuration |
| `install-helper` | Script untuk melihat panduan download binary tools |
| `project-cleanup` | Script untuk cleanup node_modules, vendor, __pycache__ |

## Auto Configuration

`config.zsh` akan otomatis:
- Menambahkan `binary-files/` dan `configs/` ke PATH
- Detect tools yang terinstall (di binary-files atau system)
- Apply konfigurasi/alias jika tool tersedia
- Load modules sesuai urutan: core → tools → git → php → bun → utils → shell → maintenance

## Project Cleanup

`project-cleanup` menghapus folder-folder besar yang bisa di-regenerate:
- `node_modules` (Node.js/npm/yarn)
- `vendor` (PHP/Composer - hanya jika ada composer.json)
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

Edit `starship.toml` untuk customize prompt. Dokumentasi: https://starship.rs/config/

### Aliases

Tambahkan alias custom di `config.zsh` atau buat file terpisah dan source dari config.zsh.
