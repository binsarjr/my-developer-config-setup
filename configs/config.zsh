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
    alias cdi="zi"  # interactive mode with fzf
fi

# =============================================================================
# starship - Shell prompt
# =============================================================================
if _has_bin starship; then
    export STARSHIP_CONFIG="$CONFIG_DIR/starship.toml"
    eval "$(starship init zsh)"
fi

# =============================================================================
# Modern CLI Tools
# =============================================================================
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
# PHP & Laravel Aliases
# =============================================================================
# Artisan
alias art="php artisan"
alias artm="php artisan migrate"
alias artmf="php artisan migrate:fresh"
alias artmfs="php artisan migrate:fresh --seed"
alias artmr="php artisan migrate:rollback"
alias arts="php artisan serve"
alias artt="php artisan tinker"
alias artc="php artisan cache:clear"
alias artcc="php artisan config:clear"
alias artrc="php artisan route:cache"
alias artrl="php artisan route:list"
alias artdb="php artisan db:seed"
alias artmk="php artisan make:"

# Composer
alias ci="composer install"
alias cu="composer update"
alias cr="composer require"
alias crd="composer require --dev"
alias cdu="composer dump-autoload"
alias cda="composer dump-autoload -o"

# Laravel Sail (Docker)
alias sail="./vendor/bin/sail"
alias sa="sail artisan"
alias sac="sail artisan cache:clear"
alias sam="sail artisan migrate"
alias samf="sail artisan migrate:fresh --seed"

# PHPUnit / Pest
alias pf="./vendor/bin/phpunit --filter"
alias pu="./vendor/bin/phpunit"
alias pest="./vendor/bin/pest"
alias pestf="./vendor/bin/pest --filter"

# Laravel utilities
alias lnew="composer create-project laravel/laravel"
alias laralog="tail -f storage/logs/laravel.log"

# Clear all Laravel caches
artclear() {
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    echo "All caches cleared!"
}

# =============================================================================
# Directory Shortcuts
# =============================================================================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# =============================================================================
# Productivity Functions
# =============================================================================
# mkcd - create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# backup - create timestamped backup
backup() { cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)" }

# extract - universal archive extractor
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *) echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# Quick Utilities
# =============================================================================
# ports - show listening ports
ports() { lsof -i -P -n | grep LISTEN }

# myip - show public IP
myip() { curl -s ifconfig.me && echo "" }

# localip - show local IP
localip() { ipconfig getifaddr en0 }

# weather - show weather (optional city)
weather() { curl -s "wttr.in/${1:-}?format=3" }

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
    echo -e "\033[1mPHP & Laravel:\033[0m"
    echo "  art, artm, artmf, artmfs, artmr  - artisan commands"
    echo "  arts, artt, artc, artcc, artrl   - serve, tinker, cache"
    echo "  artclear                         - clear all caches"
    echo "  ci, cu, cr, crd, cdu, cda        - composer"
    echo "  sail, sa, sam, samf              - Laravel Sail"
    echo "  pu, pf, pest, pestf              - testing"
    echo "  lnew, laralog                    - utilities"
    echo ""
    echo -e "\033[1mTool Aliases:\033[0m"
    echo "  ls, ll, la, lt  - lsd (if installed)"
    echo "  cat, catp       - bat (if installed)"
    echo "  lg              - lazygit (if installed)"
    echo "  cd              - zoxide smart jump (if installed)"
    echo "  cdi             - zoxide interactive (fzf picker)"
    echo ""
    echo -e "\033[1mModern CLI Tools:\033[0m"
    echo "  du              - dust (if installed)"
    echo "  df              - duf (if installed)"
    echo "  top, htop       - btm/bottom (if installed)"
    echo "  help <cmd>      - tldr (if installed)"
    echo "  ff, neofetch    - fastfetch (if installed)"
    echo ""
    echo -e "\033[1mUtilities:\033[0m"
    echo "  project-cleanup     - clean node_modules, vendor, __pycache__"
    echo "  project-cleanup -n  - dry run (preview)"
    echo "  install-helper      - show binary download guide"
    echo "  tips                - show random tips"
    echo ""
    echo -e "\033[1mProductivity:\033[0m"
    echo "  mkcd <dir>          - create & enter directory"
    echo "  backup <file>       - create timestamped backup"
    echo "  extract <archive>   - auto extract any archive"
    echo ""
    echo -e "\033[1mQuick Utilities:\033[0m"
    echo "  ports               - show listening ports"
    echo "  myip / localip      - show IP address"
    echo "  weather [city]      - show weather"
    echo ""
    echo -e "\033[1mDirectory Shortcuts:\033[0m"
    echo "  .. / ... / ....     - go up directories"
    echo ""
}

# =============================================================================
# Tips Command
# =============================================================================
tips() {
    # Git aliases (always available)
    local _tips=(
        "gs → git status"
        "ga → git add"
        "gaa → git add all"
        "gc 'msg' → git commit"
        "gca → amend commit"
        "gp → git push"
        "gpf → force push (safe)"
        "gl → git pull"
        "gd → git diff"
        "gds → diff staged"
        "glog → pretty git log"
        "gloga → log all branches"
        "gst → git stash"
        "gstp → stash pop"
        "gstl → stash list"
        "gb → git branch"
        "gbd → delete branch"
        "gco → checkout"
        "gcob → checkout -b"
        "gsw → switch branch"
        "gswc → switch -c"
        "gm → merge"
        "grh → reset HEAD"
        "grhh → reset hard"
        "gf → fetch"
        "gfa → fetch all"
        "gac 'msg' → add + commit"
        "wip → quick WIP commit"
        "nah → undo everything"
        "project-cleanup → clean deps"
        "config-help → show all aliases"
        "tips → show random tips"
        "mkcd dir → create & enter"
        "backup file → timestamped backup"
        "extract file → auto extract"
        "ports → show listening ports"
        "myip → show public IP"
        "weather → check weather"
        ".. / ... → go up directories"
        "art → php artisan"
        "artm → migrate"
        "artmfs → migrate:fresh --seed"
        "arts → artisan serve"
        "artt → artisan tinker"
        "artclear → clear all caches"
        "ci → composer install"
        "cu → composer update"
        "cr → composer require"
        "sail → Laravel Sail"
        "sa → sail artisan"
        "pu → phpunit"
        "pest → run Pest tests"
        "laralog → tail Laravel log"
    )

    # Tool-specific tips (only if installed)
    command -v lazygit &>/dev/null && _tips+=("lg → lazygit")
    command -v lsd &>/dev/null && _tips+=("ls → lsd with icons" "lt → tree view")
    command -v bat &>/dev/null && _tips+=("cat → bat with syntax highlighting")
    command -v zoxide &>/dev/null && _tips+=("cd → zoxide smart jump" "cdi → interactive directory picker")
    command -v dust &>/dev/null && _tips+=("du → dust (visual disk usage)")
    command -v duf &>/dev/null && _tips+=("df → duf (colorful disk free)")
    command -v btm &>/dev/null && _tips+=("top → btm (modern system monitor)")
    command -v tldr &>/dev/null && _tips+=("help <cmd> → tldr pages")
    command -v fastfetch &>/dev/null && _tips+=("ff → fastfetch (system info)")

    local _headers=(
        "📌 Quick Tips:"
        "🚀 Boost your workflow:"
        "⚡ Work smarter, not harder:"
        "🎯 Pro tips:"
        "✨ Did you know?"
    )

    local _hour=$(date +%H)
    if (( _hour >= 5 && _hour < 12 )); then
        _headers+=("☀️ Good morning! Here are today's tips:")
    elif (( _hour >= 12 && _hour < 17 )); then
        _headers+=("🌤️ Good afternoon! Quick tips:")
    elif (( _hour >= 17 && _hour < 21 )); then
        _headers+=("🌅 Good evening! Some tips for you:")
    else
        _headers+=("🌙 Working late? Here are some tips:")
    fi

    local _header="${_headers[$((RANDOM % ${#_headers[@]} + 1))]}"
    local _shown=()

    echo -e "\033[2m"
    echo "  $_header"
    for i in {1..5}; do
        while true; do
            local _idx=$((RANDOM % ${#_tips[@]} + 1))
            local _tip="${_tips[$_idx]}"
            if [[ ! " ${_shown[*]} " =~ " ${_tip} " ]]; then
                _shown+=("$_tip")
                echo "    💡 $_tip"
                break
            fi
        done
    done
    echo -e "\033[0m"
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
# Random Tips on Load
# =============================================================================
_config_tips=(
    "gs → git status"
    "ga → git add"
    "gaa → git add all"
    "gc 'msg' → git commit"
    "gca → amend commit"
    "gp → git push"
    "gpf → force push (safe)"
    "gl → git pull"
    "gd → git diff"
    "gds → diff staged"
    "glog → pretty git log"
    "gloga → log all branches"
    "gst → git stash"
    "gstp → stash pop"
    "gstl → stash list"
    "gb → git branch"
    "gbd → delete branch"
    "gco → checkout"
    "gcob → checkout -b"
    "gsw → switch branch"
    "gswc → switch -c"
    "gm → merge"
    "grh → reset HEAD"
    "grhh → reset hard"
    "gf → fetch"
    "gfa → fetch all"
    "gac 'msg' → add + commit"
    "wip → quick WIP commit"
    "nah → undo everything"
    "project-cleanup → clean deps"
    "config-help → show all aliases"
    "tips → show random tips"
    "mkcd dir → create & enter"
    "backup file → timestamped backup"
    "extract file → auto extract"
    "ports → show listening ports"
    "myip → show public IP"
    "weather → check weather"
    ".. / ... → go up directories"
    "art → php artisan"
    "artm → migrate"
    "artmfs → migrate:fresh --seed"
    "arts → artisan serve"
    "artt → artisan tinker"
    "artclear → clear all caches"
    "ci → composer install"
    "cu → composer update"
    "cr → composer require"
    "sail → Laravel Sail"
    "sa → sail artisan"
    "pu → phpunit"
    "pest → run Pest tests"
    "laralog → tail Laravel log"
)

# Tool-specific tips (only if installed)
command -v lazygit &>/dev/null && _config_tips+=("lg → lazygit")
command -v lsd &>/dev/null && _config_tips+=("ls → lsd with icons" "lt → tree view")
command -v bat &>/dev/null && _config_tips+=("cat → bat with syntax highlighting")
command -v zoxide &>/dev/null && _config_tips+=("cd → zoxide smart jump" "cdi → interactive directory picker")
command -v dust &>/dev/null && _config_tips+=("du → dust (visual disk usage)")
command -v duf &>/dev/null && _config_tips+=("df → duf (colorful disk free)")
command -v btm &>/dev/null && _config_tips+=("top → btm (modern system monitor)")
command -v tldr &>/dev/null && _config_tips+=("help <cmd> → tldr pages")
command -v fastfetch &>/dev/null && _config_tips+=("ff → fastfetch (system info)")

# Random headers
_headers=(
    "📌 Quick Tips:"
    "🚀 Boost your workflow:"
    "⚡ Work smarter, not harder:"
    "🎯 Pro tips:"
    "✨ Did you know?"
)

# Add time-based greeting to headers pool
_hour=$(date +%H)
if (( _hour >= 5 && _hour < 12 )); then
    _headers+=("☀️ Good morning! Here are today's tips:")
elif (( _hour >= 12 && _hour < 17 )); then
    _headers+=("🌤️ Good afternoon! Quick tips:")
elif (( _hour >= 17 && _hour < 21 )); then
    _headers+=("🌅 Good evening! Some tips for you:")
else
    _headers+=("🌙 Working late? Here are some tips:")
fi

# Pick random header
_header="${_headers[$((RANDOM % ${#_headers[@]} + 1))]}"

# Show 5 random tips (unique)
_shown=()
echo -e "\033[2m"
echo "  $_header"
for i in {1..5}; do
    while true; do
        _idx=$((RANDOM % ${#_config_tips[@]} + 1))
        _tip="${_config_tips[$_idx]}"
        if [[ ! " ${_shown[*]} " =~ " ${_tip} " ]]; then
            _shown+=("$_tip")
            echo "    💡 $_tip"
            break
        fi
    done
done
echo -e "\033[0m"
unset _config_tips _headers _shown _tip _idx _hour _header
