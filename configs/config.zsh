# Shell Configuration
# Source this file from .zshrc:
#   source "$HOME/Developers/configs/config.zsh"

CONFIG_DIR="${CONFIG_DIR:-$HOME/Developers/configs}"
BINARY_DIR="${BINARY_DIR:-$HOME/Developers/binary-files}"

# Add to PATH
export PATH="$PATH:$BINARY_DIR:$CONFIG_DIR"

# Tracking for external tools
typeset -a _external_tools=()

# Helper: check if tool exists and track source
_has_bin() {
    local tool=$1
    if [[ -x "$BINARY_DIR/$tool" ]]; then
        return 0
    elif command -v "$tool" &>/dev/null; then
        local path=$(command -v "$tool")
        _external_tools+=("$tool:$path")
        return 0
    fi
    return 1
}

# =============================================================================
# lsd - Modern ls replacement
# =============================================================================
if _has_bin lsd; then
    alias ls="lsd --color auto --header --icon auto -l --hyperlink auto -L -g -h -F"
    alias ll="lsd -la"
    alias la="lsd -a"
    alias lt="lsd --tree"
fi

# =============================================================================
# bat - Cat with syntax highlighting
# =============================================================================
if _has_bin bat; then
    alias cat="bat -p"
    alias catp="bat"  # with pager
    export BAT_THEME="TwoDark"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# =============================================================================
# lazygit - Terminal UI for git
# =============================================================================
if _has_bin lazygit; then
    alias lg="lazygit"
fi

# =============================================================================
# delta - Git diff viewer
# =============================================================================
if _has_bin delta; then
    export GIT_PAGER="delta"
fi

# =============================================================================
# fzf - Fuzzy finder
# =============================================================================
if _has_bin fzf; then
    # Use fd for file finding if available
    if _has_bin fd; then
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
    fi

    # Default options
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --info=inline
        --marker='✓'
        --pointer='▶'
    "

    # Ctrl+R - Command history
    export FZF_CTRL_R_OPTS="
        --preview 'echo {}'
        --preview-window down:3:wrap
    "

    # Ctrl+T - File selection
    if [[ -x "$BINARY_DIR/bat" ]] || command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    fi

    # Key bindings (Ctrl+R, Ctrl+T)
    if [[ -f "$CONFIG_DIR/fzf-key-bindings.zsh" ]]; then
        source "$CONFIG_DIR/fzf-key-bindings.zsh"
    else
        # Inline key bindings
        __fzf_history__() {
            local selected
            selected=$(fc -rl 1 | fzf --query="$LBUFFER" +s --tac | sed 's/ *[0-9]* *//')
            LBUFFER="$selected"
            zle redisplay
        }
        zle -N __fzf_history__
        bindkey '^R' __fzf_history__
    fi
fi

# =============================================================================
# rg - ripgrep (fast grep)
# =============================================================================
if _has_bin rg; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-rg --files --hidden --follow --glob '!.git/*'}"
fi

# =============================================================================
# zoxide - Smart cd replacement
# =============================================================================
if _has_bin zoxide; then
    eval "$(zoxide init zsh)"
    alias cd="z"
fi

# =============================================================================
# starship - Shell prompt
# =============================================================================
if _has_bin starship; then
    export STARSHIP_CONFIG="$CONFIG_DIR/starship.toml"
    eval "$(starship init zsh)"
fi

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

# =============================================================================
# Help Command
# =============================================================================
config-help() {
    echo ""
    echo -e "\033[1mGit Aliases:\033[0m"
    echo "  g, gs, ga, gaa, gc, gca, gp, gpf, gl"
    echo "  gb, gbd, gco, gcob, gsw, gswc, gm"
    echo "  gd, gds, glog, gloga"
    echo "  gst, gstp, gstl"
    echo "  grh, grhh, gclean, gf, gfa, gr"
    echo ""
    echo -e "\033[1mPower Aliases:\033[0m"
    echo "  gac 'msg'  - git add all + commit"
    echo "  wip        - quick WIP commit"
    echo "  nah        - reset hard + clean"
    echo ""
    echo -e "\033[1mTool Aliases:\033[0m"
    echo "  ls, ll, la, lt  - lsd (if installed)"
    echo "  cat, catp       - bat (if installed)"
    echo "  lg              - lazygit (if installed)"
    echo "  cd              - zoxide (if installed)"
    echo ""
    echo -e "\033[1mUtilities:\033[0m"
    echo "  project-cleanup     - clean node_modules, vendor, __pycache__"
    echo "  project-cleanup -n  - dry run (preview)"
    echo "  install-helper      - show binary download guide"
    echo ""
}

# =============================================================================
# Show recommendation for external tools
# =============================================================================
if [[ ${#_external_tools[@]} -gt 0 ]]; then
    echo "\033[33m[configs]\033[0m Tools from system (consider adding to binary-files):"
    for _item in "${_external_tools[@]}"; do
        _tool="${_item%%:*}"
        _toolpath="${_item#*:}"
        echo "  → \033[1m$_tool\033[0m ($_toolpath)"
    done
    echo ""
    echo "  Run: \033[36minstall-helper\033[0m for download guide"
    echo ""
    unset _item _tool _toolpath
fi

# Cleanup
unset -f _has_bin
unset _external_tools

# =============================================================================
# Random Tip on Load
# =============================================================================
_config_tips=(
    "gs → git status"
    "glog → pretty git log graph"
    "gac 'msg' → add all + commit"
    "wip → quick WIP commit"
    "nah → undo all changes"
    "gd → git diff, gds → diff staged"
    "lg → lazygit (if installed)"
    "project-cleanup → clean node_modules, vendor"
    "config-help → show all available aliases"
)
_tip="${_config_tips[$((RANDOM % ${#_config_tips[@]} + 1))]}"
echo -e "\033[2m💡 $_tip\033[0m"
unset _config_tips _tip
