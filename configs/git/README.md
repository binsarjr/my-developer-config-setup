# Git

Aliases untuk Git commands.

## Files

- `aliases.zsh` - Semua Git aliases

## Aliases

### Basic Operations
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Show working tree status |
| `ga` | `git add` | Stage files |
| `gaa` | `git add -A` | Stage ALL changes |
| `gc` | `git commit -m` | Commit with message |
| `gca` | `git commit --amend` | Amend last commit |
| `gp` | `git push` | Push to remote |
| `gpf` | `git push --force-with-lease` | Force push (safe) |
| `gl` | `git pull` | Pull from remote |

### Branching
| Alias | Command | Description |
|-------|---------|-------------|
| `gb` | `git branch` | List branches |
| `gbd` | `git branch -d` | Delete branch |
| `gco` | `git checkout` | Checkout |
| `gcob` | `git checkout -b` | Create & checkout branch |
| `gsw` | `git switch` | Switch branch |
| `gswc` | `git switch -c` | Create & switch branch |
| `gm` | `git merge` | Merge branch |

### Viewing
| Alias | Command | Description |
|-------|---------|-------------|
| `gd` | `git diff` | Show unstaged changes |
| `gds` | `git diff --staged` | Show staged changes |
| `glog` | `git log --oneline --graph` | Pretty log |
| `gloga` | `git log --all` | Log all branches |

### Stash
| Alias | Command | Description |
|-------|---------|-------------|
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `gstl` | `git stash list` | List stashes |

### Reset & Clean
| Alias | Command | Description |
|-------|---------|-------------|
| `grh` | `git reset HEAD` | Unstage files |
| `grhh` | `git reset HEAD --hard` | Reset hard |
| `gclean` | `git clean -fd` | Remove untracked |

### Quick Combos
| Alias | Command | Description |
|-------|---------|-------------|
| `gac` | `git add -A && git commit -m` | Add all & commit |
| `wip` | `git add -A && git commit -m "WIP"` | WIP commit |
| `nah` | `git reset --hard && git clean -df` | Undo everything |

## Usage

```zsh
# Quick status
gs

# Add all and commit
gac "feat: add new feature"

# Quick WIP commit
wip

# Undo all changes
nah
```
