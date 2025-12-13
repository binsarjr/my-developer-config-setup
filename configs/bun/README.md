# Bun

Aliases for Bun - JavaScript/TypeScript runtime, package manager, and test runner.

## Files

- `aliases.zsh` - Bun command aliases

## Aliases

### Package Manager
| Alias | Command | Description |
|-------|---------|-------------|
| `bi` | `bun install` | Install dependencies from bun.lockb |
| `ba` | `bun add` | Add package to dependencies |
| `bad` | `bun add -d` | Add package to devDependencies |
| `brm` | `bun remove` | Remove package |
| `bu` | `bun update` | Update all packages |
| `bx` | `bunx` | Execute package from npm (like npx) |

### Runtime
| Alias | Command | Description |
|-------|---------|-------------|
| `br` | `bun run` | Run script or file |
| `bd` | `bun run dev` | Run dev script |
| `bb` | `bun run build` | Run build script |
| `bs` | `bun run start` | Run start script |

### Testing
| Alias | Command | Description |
|-------|---------|-------------|
| `bt` | `bun test` | Run all tests |
| `btw` | `bun test --watch` | Watch mode |
| `btc` | `bun test --coverage` | With coverage |

## Usage

```zsh
# Install dependencies
bi

# Add package
ba react
bad typescript

# Run scripts
bd          # dev server
bb          # build
bs          # start

# Testing
bt          # run tests
btw         # watch mode

# Execute npm package
bx create-next-app
```

## Requirements

Bun must be installed. Install via:

```zsh
# macOS/Linux
curl -fsSL https://bun.sh/install | bash

# Homebrew
brew install oven-sh/bun/bun
```

## Notes

- Aliases only load if `bun` is in PATH
- Bun is 4x faster than Node.js
- Native TypeScript/JSX support
- Drop-in replacement for npm/yarn
