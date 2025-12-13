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

# Cleanup helper function and tracking array
unset -f _has_bin
unset _external_tools

# =============================================================================
# Introduction / Welcome Message
# =============================================================================
_show_ascii_header() {
    echo "  ██████╗ ██╗███╗   ██╗███████╗ █████╗ ██████╗ "
    echo "  ██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██╔══██╗"
    echo "  ██████╔╝██║██╔██╗ ██║███████╗███████║██████╔╝"
    echo "  ██╔══██╗██║██║╚██╗██║╚════██║██╔══██║██╔══██╗"
    echo "  ██████╔╝██║██║ ╚████║███████║██║  ██║██║  ██║"
    echo "  ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝"
}

_show_profile() {
    echo -e "\033[2m              Code craftsman by night 🌙\033[0m"
    echo ""
    echo -e "\033[2m  Backend · Bots · Automation\033[0m"
    echo -e "\033[2m  github.com/binsarjr  ·  binsarjr.com\033[0m"
}

_show_quick_info() {
    echo -e "\033[2m  ─────────────────────────────────────────────\033[0m"
    echo ""

    # System info line
    local sys_info=""

    # Uptime (format: 21h 34m)
    local uptime_raw=$(uptime | sed 's/.*up //' | sed 's/,.*//' | xargs)
    local uptime_str=$(echo "$uptime_raw" | sed -E 's/([0-9]+):([0-9]+)/\1h \2m/')
    sys_info="Up: $uptime_str"

    # Docker status
    if command -v docker &>/dev/null; then
        if docker info &>/dev/null 2>&1; then
            local containers=$(docker ps -q 2>/dev/null | wc -l | tr -d ' ')
            sys_info="$sys_info  ·  Docker: $containers running"
        else
            sys_info="$sys_info  ·  Docker: stopped"
        fi
    fi

    echo -e "  \033[1m🚀 System\033[0m"
    echo -e "\033[2m     $sys_info\033[0m"
    echo ""

    # Project info line
    local info=""
    # Git info
    if git rev-parse --git-dir &>/dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        [[ $changes -eq 0 ]] && info="Git: $branch (clean)" || info="Git: $branch ($changes changes)"
    fi

    # Current dir (shortened)
    local cwd="${PWD/#$HOME/~}"
    [[ -n "$info" ]] && info="$info  ·  $cwd" || info="$cwd"

    echo -e "  \033[1m📂 Project\033[0m"
    echo -e "\033[2m     $info\033[0m"
    echo ""
}

_show_intro() {
    echo ""
    _show_ascii_header
    _show_profile
    _show_quick_info
}

_show_intro

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
command -v jq &>/dev/null && _config_tips+=("jq → JSON processor")

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

# Configurable tips count (default 10)
_tips_count=${WELCOME_TIPS_COUNT:-10}

# Collect random tips into array
_shown=()
_tips_to_show=()
for i in {1..$_tips_count}; do
    while true; do
        _idx=$((RANDOM % ${#_config_tips[@]} + 1))
        _tip="${_config_tips[$_idx]}"
        if [[ ! " ${_shown[*]} " =~ " ${_tip} " ]]; then
            _shown+=("$_tip")
            _tips_to_show+=("$_tip")
            break
        fi
    done
done

# Display tips in 2 columns
echo -e "\033[2m"
echo "  $_header"
_half=$(( (_tips_count + 1) / 2 ))

# Calculate max width from left column tips
_max_width=0
for i in {1..$_half}; do
    _len=${#_tips_to_show[$i]}
    (( _len > _max_width )) && _max_width=$_len
done

# Display with dynamic width
for i in {1..$_half}; do
    _left="${_tips_to_show[$i]}"
    _right_idx=$((i + _half))
    _right="${_tips_to_show[$_right_idx]}"

    if [[ -n "$_right" ]]; then
        printf "    💡 %-${_max_width}s  💡 %s\n" "$_left" "$_right"
    else
        printf "    💡 %s\n" "$_left"
    fi
done
echo ""
echo -e "  ───"
echo -e "  💡 Use \033[0m\033[1maf\033[0m\033[2m to search all aliases"
echo -e "\033[0m"
unset _config_tips _headers _shown _tip _idx _hour _header _tips_count _tips_to_show _half _left _right _right_idx _max_width _len
