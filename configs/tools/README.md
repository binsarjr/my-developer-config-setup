# Tools

Configuration for modern CLI tools.

## Files

- `config.zsh` - Tool configurations & aliases

## Supported Tools

### lsd (Modern ls)
| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `lsd -l` | List files with icons |
| `ll` | `lsd -la` | List all files |
| `la` | `lsd -a` | List hidden only |
| `lt` | `lsd --tree` | Tree view |

### bat (Modern cat)
| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat -pp` | View with syntax highlight |
| `catp` | `bat` | View with pager |

### lazygit
| Alias | Command | Description |
|-------|---------|-------------|
| `lg` | `lazygit` | Git TUI |

### zoxide (Smart cd)
| Alias | Command | Description |
|-------|---------|-------------|
| `cdi` | `zi` | Interactive picker (fzf) |

### dust (Modern du)
| Alias | Command | Description |
|-------|---------|-------------|
| `du` | `dust` | Disk usage visualizer |

### duf (Modern df)
| Alias | Command | Description |
|-------|---------|-------------|
| `df` | `duf` | Disk free colorful |

### bottom (Modern top)
| Alias | Command | Description |
|-------|---------|-------------|
| `top` | `btm` | System monitor |
| `htop` | `btm` | System monitor |

### curlie (Pretty curl)
| Alias | Command | Description |
|-------|---------|-------------|
| `curl` | `curlie` | HTTP client with pretty output |
| `rawcurl` | `command curl` | Native curl (no formatting) |

## Auto-configuration

- **delta**: Automatically configures Git to use delta for diffs
- **fzf**: Sets up Ctrl+R (history) and Ctrl+T (file picker)
- **starship**: Loads custom prompt from `starship.toml`

## Installation

Tools can be installed to `binary-files/` or via Homebrew.
Run `install-helper` to see download guide.

## Dependencies

Tools are conditionally loaded only if installed.
