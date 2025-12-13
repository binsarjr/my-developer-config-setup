# =============================================================================
# Tool Configurations
# lsd, bat, lazygit, delta, fzf, rg, zoxide, starship, dust, duf, btm, tldr, fastfetch
# =============================================================================

# lsd - Modern ls replacement
if _has_bin lsd; then
    _reg ls  "lsd --color auto --header --icon auto -l --hyperlink auto -L -g -h -F" "List files with icons, sizes & git status (lsd)" "file,list,lsd"
    _reg ll  "lsd -la"                  "List ALL files including hidden (lsd)" "file,list,lsd"
    _reg la  "lsd -a"                   "List hidden files only (lsd)" "file,list,lsd"
    _reg lt  "lsd --tree"               "Display directory structure as tree (lsd)" "file,list,tree,lsd"
fi

# bat - Cat with syntax highlighting
if _has_bin bat; then
    _reg cat  "bat -p"                  "View file with syntax highlighting (bat)" "file,view,bat"
    _reg catp "bat"                     "View file with pager & line numbers (bat)" "file,view,bat"
    export BAT_THEME="TwoDark"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# lazygit - Terminal UI for git
if _has_bin lazygit; then
    _reg lg "lazygit"                   "Open Git terminal UI for visual operations" "git,ui,lazygit"
fi

# delta - Git diff viewer
if _has_bin delta; then
    _reg delta "delta"                  "Git diff viewer with syntax highlighting" "git,diff,delta"

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

# fd - Fast file finder
if _has_bin fd; then
    _reg fd "fd"                        "Fast file finder (find alternative)" "file,find,fd"
fi

# fzf - Fuzzy finder
if _has_bin fzf; then
    _reg fzf "fzf"                      "Fuzzy finder for files & text" "search,fzf"

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

    # Key bindings (Ctrl+R for history search)
    __fzf_history__() {
        local selected
        selected=$(fc -rl 1 | fzf --query="$LBUFFER" +s --tac | sed 's/ *[0-9]* *//')
        LBUFFER="$selected"
        zle redisplay
    }
    zle -N __fzf_history__
    bindkey '^R' __fzf_history__
fi

# rg - ripgrep (fast grep)
if _has_bin rg; then
    _reg rg "rg"                        "Fast grep (ripgrep)" "search,grep,rg"
    export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND:-rg --files --hidden --follow --glob '!.git/*'}"
fi

# zoxide - Smart cd replacement
if _has_bin zoxide; then
    eval "$(zoxide init zsh)"
    _reg cd  "z"                        "Smart directory jump based on history (zoxide)" "nav,cd,zoxide"
    _reg cdi "zi"                       "Interactive directory picker with fzf (zoxide)" "nav,cd,zoxide,fzf"
fi

# starship - Shell prompt
if _has_bin starship; then
    export STARSHIP_CONFIG="$CONFIG_DIR/starship.toml"
    eval "$(starship init zsh)"
fi

# dust - Better du (disk usage visualizer)
if _has_bin dust; then
    _reg du "dust"                      "Show disk usage with visual bar chart (dust)" "system,disk,dust"
fi

# duf - Better df (disk free)
if _has_bin duf; then
    _reg df "duf"                       "Show disk space with colorful table (duf)" "system,disk,duf"
fi

# bottom - Better top/htop (system monitor)
if _has_bin btm; then
    _reg top  "btm"                     "Interactive system monitor with graphs (bottom)" "system,monitor,btm"
    _reg htop "btm"                     "Interactive system monitor with graphs (bottom)" "system,monitor,btm"
fi

# lazydocker - Docker TUI
if _has_bin lazydocker; then
    _reg ld "lazydocker"                "Docker TUI for containers, images & logs" "docker,lazydocker"
fi

# gron - Make JSON greppable
if _has_bin gron; then
    _reg gron   "gron"                  "Flatten JSON to path=value (greppable)" "json,gron"
    _reg ungron "gron -u"               "Convert gron output back to JSON" "json,gron"
fi

# fx - Interactive JSON viewer
if _has_bin fx; then
    _reg fx "fx"                        "Interactive JSON viewer & processor" "json,fx"
fi

# jq - JSON processor
if _has_bin jq; then
    _reg jq "jq"                        "JSON processor & transformer" "json,jq"
fi

# curlie - curl with pretty output
if _has_bin curlie; then
    _reg curl    "curlie"               "Pretty HTTP client (curlie)" "http,curl,curlie"
    _reg rawcurl "command curl"         "Native curl (no formatting)" "http,curl,raw"
fi
