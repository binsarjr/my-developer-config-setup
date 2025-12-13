# Binary Files

Folder for storing standalone CLI binary tools.

## Download Guide

Run `install-helper` to view download guide matching your Mac architecture.

## Recommended Tools

| Tool | Description | GitHub |
|------|-------------|--------|
| fzf | Fuzzy finder | [junegunn/fzf](https://github.com/junegunn/fzf/releases) |
| rg | ripgrep - fast text search | [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep/releases) |
| fd | Fast `find` alternative | [sharkdp/fd](https://github.com/sharkdp/fd/releases) |
| bat | `cat` with syntax highlighting | [sharkdp/bat](https://github.com/sharkdp/bat/releases) |
| lsd | Modern `ls` with icons | [lsd-rs/lsd](https://github.com/lsd-rs/lsd/releases) |
| lazygit | Terminal UI for git | [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit/releases) |
| delta | Git diff viewer | [dandavison/delta](https://github.com/dandavison/delta/releases) |
| starship | Shell prompt | [starship/starship](https://github.com/starship/starship/releases) |
| zoxide | Smart cd replacement | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide/releases) |

## Manual Installation

```bash
# 1. Download from GitHub releases
# 2. Extract
unzip file.zip          # for .zip
tar -xzf file.tar.gz    # for .tar.gz

# 3. Move binary to this folder
mv <binary> ~/Developers/binary-files/

# 4. Set executable permission
chmod +x ~/Developers/binary-files/<binary>
```

## Configuration

See [configs/](../configs/) for shell configuration.
