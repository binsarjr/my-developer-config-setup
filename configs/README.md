# Configs

Shell configuration files untuk development environment.

## Setup

Tambahkan satu baris ini ke `~/.zshrc`:

```bash
source "$HOME/Developers/configs/config.zsh"
```

## Files

| File | Deskripsi |
|------|-----------|
| `config.zsh` | Main shell configuration - aliases, PATH, tool configs |
| `starship.toml` | Starship prompt configuration |
| `install-helper` | Script untuk melihat panduan download binary tools |

## Auto Configuration

`config.zsh` akan otomatis:
- Menambahkan `binary-files/` dan `configs/` ke PATH
- Detect tools yang terinstall (di binary-files atau system)
- Apply konfigurasi/alias jika tool tersedia
- Menampilkan rekomendasi jika ada tools dari system PATH

## Tool Configurations

| Tool | Konfigurasi Otomatis |
|------|---------------------|
| lsd | `ls` → lsd dengan icons & colors |
| bat | `cat` → bat dengan syntax highlighting |
| lazygit | `lg` → lazygit |
| delta | Git diff dengan syntax highlighting |
| fzf | Ctrl+R (history), Ctrl+T (file picker) |
| fd | Digunakan fzf untuk pencarian file |
| rg | Digunakan fzf untuk pencarian konten |
| starship | Shell prompt dengan config dari `starship.toml` |

## Customization

### Starship Prompt

Edit `starship.toml` untuk customize prompt. Dokumentasi: https://starship.rs/config/

### Aliases

Tambahkan alias custom di `config.zsh` atau buat file terpisah dan source dari config.zsh.
