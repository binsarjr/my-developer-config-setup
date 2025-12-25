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

    # Apply delta git configuration
    _delta_apply_git_config() {
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only"
        git config --global delta.navigate true
        git config --global delta.line-numbers true
        git config --global delta.side-by-side false
        git config --global merge.conflictStyle diff3
        git config --global diff.colorMoved default
    }

    # Configure git to use delta (with user confirmation)
    _delta_configure_git() {
        local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/shell-config"
        local state_file="$state_dir/delta-configured"

        # Already configured in git?
        [[ "$(git config --global core.pager 2>/dev/null)" == "delta" ]] && return 0

        # Check saved choice
        if [[ -f "$state_file" ]]; then
            local choice=$(cat "$state_file" 2>/dev/null)
            [[ "$choice" == "no" ]] && return 0
            [[ "$choice" == "yes" ]] && { _delta_apply_git_config; return 0; }
        fi

        # Prompt user (one-time)
        echo -e "\033[36m[delta]\033[0m Delta detected. Configure git to use it for diffs?"
        echo -e "\033[2m  Sets: core.pager, interactive.diffFilter, delta.navigate,"
        echo -e "  delta.line-numbers, delta.side-by-side, merge.conflictStyle, diff.colorMoved\033[0m"
        echo -n "Configure git for delta? [Y/n]: "
        read -r response

        # Save choice
        mkdir -p "$state_dir"
        if [[ -z "$response" || "$response" =~ ^[Yy]$ ]]; then
            echo "yes" > "$state_file"
            _delta_apply_git_config
            echo -e "\033[32m[delta]\033[0m Git configured to use delta!"
        else
            echo "no" > "$state_file"
            echo -e "\033[2m[delta]\033[0m Skipped. Run 'delta-setup' to configure later.\033[0m"
        fi
    }

    # Manual setup command (if user declined initially)
    delta-setup() {
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo "Usage: delta-setup"
            echo "  Configure git to use delta for diffs"
            echo ""
            echo "This will set:"
            echo "  core.pager = delta"
            echo "  interactive.diffFilter = delta --color-only"
            echo "  delta.navigate = true"
            echo "  delta.line-numbers = true"
            echo "  delta.side-by-side = false"
            echo "  merge.conflictStyle = diff3"
            echo "  diff.colorMoved = default"
            return 0
        fi

        local state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/shell-config"
        local state_file="$state_dir/delta-configured"

        _delta_apply_git_config
        mkdir -p "$state_dir"
        echo "yes" > "$state_file"
        echo -e "\033[32m[delta]\033[0m Git configured to use delta!"
    }
    _reg delta-setup "delta-setup" "Configure git to use delta for diffs" "git,delta,setup"

    # Reset delta choice (if user changes mind)
    delta-reset() {
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo "Usage: delta-reset"
            echo "  Reset delta configuration choice"
            echo "  You will be prompted again on next shell start"
            return 0
        fi

        local state_file="${XDG_STATE_HOME:-$HOME/.local/state}/shell-config/delta-configured"
        rm -f "$state_file" 2>/dev/null
        echo -e "\033[2m[delta]\033[0m Choice reset. Restart shell to be prompted again.\033[0m"
    }
    _reg delta-reset "delta-reset" "Reset delta configuration choice" "git,delta,reset"

    _delta_configure_git
    unset -f _delta_configure_git _delta_apply_git_config
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

# Claude Code - AI coding assistant
if _has_bin claude; then
    _reg cc "claude"                    "Claude Code AI assistant" "ai,claude,code"

    # ai - Claude AI assistant with prompt wrapper
    ai() {
        # Disable glob expansion for arguments
        setopt localoptions noglob

        [[ "$1" == "-h" || "$1" == "--help" ]] && {
            echo "Usage: ai <prompt>"
            echo ""
            echo "Examples:"
            echo "  ai install nodejs"
            echo "  ai refactor this function"
            echo "  ai explain docker volumes"
            echo "  ai ada jadwal apa aku hari ini?"
            echo ""
            echo "Sends your prompt to Claude with Bash tools enabled."
            echo "Use 'cc' for interactive Claude Code sessions."
            return 0
        }

        [[ $# -eq 0 ]] && {
            ai --help
            return 1
        }

        local system_prompt="You are a helpful development assistant. Provide concise, practical advice for coding tasks."
        local user_prompt="$*"

        claude --settings "$HOME/Developers/.claude/settings.json" \
               -p "${system_prompt} User request: ${user_prompt}" \
               --allowedTools "Bash" \
               --model sonnet
    }

    _reg ai "ai" "Claude AI assistant for dev tasks" "ai,claude,code,assistant"
fi

# MacVim - GUI Vim for macOS
if _has_bin mvim; then
    _reg gvim "mvim"                    "Open MacVim GUI editor" "editor,vim,macvim"

    # gvim-doctor - Check MacVim dependencies (relative to CONFIG_DIR)
    GVIM_DOCTOR="${CONFIG_DIR}/../editors/macvim/gvim-doctor"
    if [[ -x "$GVIM_DOCTOR" ]]; then
        _reg gvim-doctor "$GVIM_DOCTOR" "Check MacVim dependencies & config" "editor,vim,macvim,doctor"
    fi
fi
