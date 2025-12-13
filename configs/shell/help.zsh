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
    echo -e "\033[1mCache Management:\033[0m"
    echo "  cache-cleanup       - interactive cache cleanup (verbose)"
    echo "  cache-cleanup -q    - quick mode (clean all, minimal output)"
    echo "  cache-help          - show individual cache cleanup commands"
    echo ""
    echo -e "\033[1mDirectory Shortcuts:\033[0m"
    echo "  .. / ... / ....     - go up directories"
    echo ""
}

# =============================================================================
# Tips Command
# =============================================================================
tips() {
    # Parse arguments
    local _count=5
    case "$1" in
        -h|--help)
            echo "Usage: tips [count]"
            echo ""
            echo "  tips        Show 5 random tips (default)"
            echo "  tips 10     Show 10 random tips"
            echo "  tips -h     Show this help"
            return 0
            ;;
        ''|*[!0-9]*)
            # No argument or non-numeric - use default
            ;;
        *)
            _count=$1
            ;;
    esac

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
    command -v jq &>/dev/null && _tips+=("jq → JSON processor")

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

    # Cap count to available tips
    (( _count > ${#_tips[@]} )) && _count=${#_tips[@]}

    echo -e "\033[2m"
    echo "  $_header"
    for i in $(seq 1 $_count); do
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
