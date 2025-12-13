# Core

Fungsi inti yang digunakan oleh module lain.

## Files

- `alias-registry.zsh` - Sistem registry alias dengan deskripsi

## Functions

### `_reg <name> <command> <description>`
Register alias dengan deskripsi. Digunakan oleh semua module untuk mendefinisikan alias.

```zsh
_reg gs "git status" "Show Git working tree status"
```

## Commands

| Command | Description |
|---------|-------------|
| `alias-finder` / `af` | Cari alias dengan fzf picker |
| `alias-list` | Tampilkan semua registered aliases |

## Usage

```zsh
# Cari alias
af

# List semua alias
alias-list
```
