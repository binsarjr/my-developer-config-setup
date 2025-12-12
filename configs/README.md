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
| `project-cleanup` | Script untuk cleanup node_modules, vendor, __pycache__ |

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
| zoxide | `cd` → smart cd dengan history |
| starship | Shell prompt dengan config dari `starship.toml` |

## Git Aliases

`config.zsh` menyediakan git aliases untuk mempercepat workflow:

| Alias | Command | Deskripsi |
|-------|---------|-----------|
| `g` | `git` | Shorthand git |
| `gs` | `git status` | Status |
| `ga` | `git add` | Add file |
| `gaa` | `git add -A` | Add semua file |
| `gc` | `git commit -m` | Commit dengan message |
| `gca` | `git commit --amend` | Amend commit |
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Force push (safe) |
| `gl` | `git pull` | Pull |
| `gb` | `git branch` | List branch |
| `gbd` | `git branch -d` | Delete branch |
| `gco` | `git checkout` | Checkout |
| `gcob` | `git checkout -b` | Checkout new branch |
| `gsw` | `git switch` | Switch branch |
| `gswc` | `git switch -c` | Switch & create branch |
| `gm` | `git merge` | Merge |
| `gd` | `git diff` | Diff |
| `gds` | `git diff --staged` | Diff staged |
| `glog` | `git log --oneline --graph --decorate` | Log graph |
| `gloga` | `git log --oneline --graph --decorate --all` | Log graph all |
| `gst` | `git stash` | Stash |
| `gstp` | `git stash pop` | Stash pop |
| `gstl` | `git stash list` | Stash list |
| `grh` | `git reset HEAD` | Reset HEAD |
| `grhh` | `git reset HEAD --hard` | Hard reset |
| `gclean` | `git clean -fd` | Clean untracked |
| `gf` | `git fetch` | Fetch |
| `gfa` | `git fetch --all` | Fetch all |
| `gr` | `git remote -v` | Remote list |

### Power Aliases

| Alias | Deskripsi |
|-------|-----------|
| `gac "message"` | Add all + commit |
| `wip` | Quick WIP commit |
| `nah` | Reset hard + clean (undo everything) |

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
