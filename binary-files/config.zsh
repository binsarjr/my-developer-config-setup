# Binary Files Configuration
# Source this file from .zshrc:
#   source "$HOME/Developers/binary-files/config.zsh"

BINARY_DIR="${BINARY_DIR:-$HOME/Developers/binary-files}"

# Add to PATH
export PATH="$PATH:$BINARY_DIR"

# Helper: check if tool exists in binary-files
_has_bin() { [[ -x "$BINARY_DIR/$1" ]]; }

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
    alias cat="bat --paging=never"
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
    if _has_bin bat; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    fi

    # Key bindings (Ctrl+R, Ctrl+T)
    if [[ -f "$BINARY_DIR/fzf-key-bindings.zsh" ]]; then
        source "$BINARY_DIR/fzf-key-bindings.zsh"
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
# fd - Fast file finder (used by fzf, no alias to avoid conflicts)
# =============================================================================
# fd is configured above for fzf integration

# =============================================================================
# rg - ripgrep (fast grep)
# =============================================================================
if _has_bin rg; then
    # Use rg for fzf grep if available
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-rg --files --hidden --follow --glob '!.git/*'}"
fi

# Cleanup helper function
unset -f _has_bin
