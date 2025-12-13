# =============================================================================
# Tool Configurations
# lsd, bat, lazygit, delta, fzf, rg, zoxide, starship, dust, duf, btm, tldr, fastfetch
# =============================================================================

# lsd - Modern ls replacement
if _has_bin lsd; then
    alias ls="lsd --color auto --header --icon auto -l --hyperlink auto -L -g -h -F"
    alias ll="lsd -la"
    alias la="lsd -a"
    alias lt="lsd --tree"
fi

# bat - Cat with syntax highlighting
if _has_bin bat; then
    alias cat="bat -p"
    alias catp="bat"  # with pager
    export BAT_THEME="TwoDark"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# lazygit - Terminal UI for git
if _has_bin lazygit; then
    alias lg="lazygit"
fi

# delta - Git diff viewer
if _has_bin delta; then
    # Configure git to use delta (only if not already configured)
    if [[ "$(git config --global core.pager 2>/dev/null)" != "delta" ]]; then
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.line-numbers true
        git config --global delta.side-by-side false
        git config --global merge.conflictStyle diff3
        git config --global diff.colorMoved default
    fi
fi

# fzf - Fuzzy finder
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

# rg - ripgrep (fast grep)
if _has_bin rg; then
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-rg --files --hidden --follow --glob '!.git/*'}"
fi

# zoxide - Smart cd replacement
if _has_bin zoxide; then
    eval "$(zoxide init zsh)"
    alias cd="z"
    alias cdi="zi"  # interactive mode with fzf
fi

# starship - Shell prompt
if _has_bin starship; then
    export STARSHIP_CONFIG="$CONFIG_DIR/starship.toml"
    eval "$(starship init zsh)"
fi

# dust - Better du (disk usage visualizer)
if _has_bin dust; then
    alias du="dust"
fi

# duf - Better df (disk free)
if _has_bin duf; then
    alias df="duf"
fi

# bottom - Better top/htop (system monitor)
if _has_bin btm; then
    alias top="btm"
    alias htop="btm"
fi

# tealdeer - Better man pages (tldr)
if _has_bin tldr; then
    alias help="tldr"
fi

# fastfetch - System info display
if _has_bin fastfetch; then
    alias ff="fastfetch"
    alias neofetch="fastfetch"
fi
