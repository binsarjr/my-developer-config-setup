# Binary Files

Folder untuk menyimpan binary CLI tools standalone.

## Quick Start

```bash
# Lihat panduan download sesuai arsitektur Mac kamu
./install.sh
```

## Tools yang Direkomendasikan

| Tool | Deskripsi | GitHub |
|------|-----------|--------|
| fzf | Fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf/releases) |
| rg | ripgrep - pencarian teks cepat | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep/releases) |
| fd | Alternatif `find` yang cepat | [sharkdp/fd](https://github.com/sharkdp/fd/releases) |
| bat | `cat` dengan syntax highlighting | [sharkdp/bat](https://github.com/sharkdp/bat/releases) |
| lazygit | Terminal UI untuk git | [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit/releases) |
| delta | Git diff viewer | [dandavison/delta](https://github.com/dandavison/delta/releases) |

## Filename Pattern per Arsitektur

### Apple Silicon (M1/M2/M3 - arm64)

| Tool | Filename Pattern |
|------|------------------|
| fzf | `fzf-*-darwin_arm64.zip` |
| rg | `ripgrep-*-aarch64-apple-darwin.tar.gz` |
| fd | `fd-v*-aarch64-apple-darwin.tar.gz` |
| bat | `bat-v*-aarch64-apple-darwin.tar.gz` |
| lazygit | `lazygit_*_Darwin_arm64.tar.gz` |
| delta | `delta-*-aarch64-apple-darwin.tar.gz` |

### Intel (x86_64)

| Tool | Filename Pattern |
|------|------------------|
| fzf | `fzf-*-darwin_amd64.zip` |
| rg | `ripgrep-*-x86_64-apple-darwin.tar.gz` |
| fd | `fd-v*-x86_64-apple-darwin.tar.gz` |
| bat | `bat-v*-x86_64-apple-darwin.tar.gz` |
| lazygit | `lazygit_*_Darwin_x86_64.tar.gz` |
| delta | `delta-*-x86_64-apple-darwin.tar.gz` |

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

# 5. Verifikasi
which <binary>
<binary> --version
```

## Setup PATH

Tambahkan ke `~/.zshrc`:

```bash
export PATH="$PATH:$HOME/Developers/binary-files"
```

Lalu reload: `source ~/.zshrc`
