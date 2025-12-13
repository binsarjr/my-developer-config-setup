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
_show_intro() {
    echo ""
    echo -e "\033[2m  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\033[1m  Binsar Dwi Jasuma\033[0m"
    echo -e "\033[2m  \"Code craftsman by night 🌙\"\033[0m"
    echo ""
    echo -e "\033[2m  Software Engineer — Backend, Bots & Automation\033[0m"
    echo -e "\033[2m  github.com/binsarjr  ·  binsarjr.com\033[0m"
    echo -e "\033[2m  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
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
