# =============================================================================
# Git Aliases
# =============================================================================

# Basic operations
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git pull"

# Branching
alias gb="git branch"
alias gbd="git branch -d"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gsw="git switch"
alias gswc="git switch -c"
alias gm="git merge"

# Viewing
alias gd="git diff"
alias gds="git diff --staged"
alias glog="git log --oneline --graph --decorate"
alias gloga="git log --oneline --graph --decorate --all"

# Stash
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"

# Reset & Clean
alias grh="git reset HEAD"
alias grhh="git reset HEAD --hard"
alias gclean="git clean -fd"

# Remote
alias gf="git fetch"
alias gfa="git fetch --all"
alias gr="git remote -v"

# Quick combos
alias gac='git add -A && git commit -m'
alias wip='git add -A && git commit -m "WIP"'
alias nah='git reset --hard && git clean -df'
