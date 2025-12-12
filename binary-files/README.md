# Binary Files

Folder untuk menyimpan binary CLI tools standalone.

## Download Guide

Jalankan `install-helper` untuk melihat panduan download sesuai arsitektur Mac.

## Tools yang Direkomendasikan

| Tool | Deskripsi | GitHub |
|------|-----------|--------|
| fzf | Fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf/releases) |
| rg | ripgrep - pencarian teks cepat | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep/releases) |
| fd | Alternatif `find` yang cepat | [sharkdp/fd](https://github.com/sharkdp/fd/releases) |
| bat | `cat` dengan syntax highlighting | [sharkdp/bat](https://github.com/sharkdp/bat/releases) |
| lsd | `ls` modern dengan icons | [lsd-rs/lsd](https://github.com/lsd-rs/lsd/releases) |
| lazygit | Terminal UI untuk git | [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit/releases) |
| delta | Git diff viewer | [dandavison/delta](https://github.com/dandavison/delta/releases) |
| starship | Shell prompt | [starship/starship](https://github.com/starship/starship/releases) |
| zoxide | Smart cd replacement | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide/releases) |

## Cara Install Manual

```bash
# 1. Download dari GitHub releases
# 2. Extract
unzip file.zip          # untuk .zip
tar -xzf file.tar.gz    # untuk .tar.gz

# 3. Pindahkan binary ke folder ini
mv <binary> ~/Developers/binary-files/

# 4. Set permission executable
chmod +x ~/Developers/binary-files/<binary>
```

## Konfigurasi

Lihat [configs/](../configs/) untuk shell configuration.
