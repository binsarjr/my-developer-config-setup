# Binary Files

Folder ini digunakan untuk menyimpan binary tools standalone yang tidak tersedia via package manager atau versi spesifik yang dibutuhkan untuk development.

## Kegunaan

- Menyimpan binary CLI tools (fzf, ripgrep, dll)
- Versi spesifik tools yang tidak ada di Homebrew
- Tools custom atau hasil build sendiri

## Setup PATH di macOS

Agar binary di folder ini bisa dijalankan dari mana saja, tambahkan ke PATH.

### 1. Edit ~/.zshrc

```bash
nano ~/.zshrc
```

### 2. Tambahkan baris berikut di akhir file

```bash
# Custom binary tools
export PATH="$HOME/Developers/binary-files:$PATH"
```

### 3. Reload konfigurasi

```bash
source ~/.zshrc
```

Atau tutup dan buka terminal baru.

### 4. Verifikasi

```bash
# Cek PATH sudah terdaftar
echo $PATH | tr ':' '\n' | grep binary-files

# Coba jalankan binary (contoh: fzf)
which fzf
```

## Catatan

- File binary di folder ini di-gitignore (tidak ter-track git)
- Hanya file `.gitkeep` yang di-track untuk menjaga folder tetap ada
- Pastikan binary memiliki permission executable: `chmod +x <nama-binary>`
