# =============================================================================
# Cache Cleanup
# =============================================================================

# Interactive cache cleanup (fzf multi-select or fallback)
# Usage: cache-cleanup [-q|--quick]
cache-cleanup() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: cache-cleanup [-q|--quick]"
        echo ""
        echo "  cache-cleanup      Interactive mode (fzf multi-select)"
        echo "  cache-cleanup -q   Quick mode (clean all, minimal output)"
        echo "  cache-cleanup -h   Show this help"
        echo ""
        echo "Cleans: Homebrew, Composer, npm, yarn, pnpm, bun, pip, Docker"
        return 0
    }

    local quick=false
    [[ "$1" == "-q" || "$1" == "--quick" ]] && quick=true

    local caches=()
    local labels=()

    # Build list of available caches
    if command -v brew &>/dev/null; then
        caches+=("brew")
        labels+=("Homebrew")
    fi
    if command -v composer &>/dev/null || [[ -x "$BINARY_DIR/composer" ]]; then
        caches+=("composer")
        labels+=("Composer")
    fi
    if command -v npm &>/dev/null; then
        caches+=("npm")
        labels+=("npm")
    fi
    if command -v yarn &>/dev/null; then
        caches+=("yarn")
        labels+=("yarn")
    fi
    if command -v pnpm &>/dev/null; then
        caches+=("pnpm")
        labels+=("pnpm")
    fi
    if command -v bun &>/dev/null; then
        caches+=("bun")
        labels+=("bun")
    fi
    if command -v pip3 &>/dev/null; then
        caches+=("pip")
        labels+=("pip")
    fi
    if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
        caches+=("docker")
        labels+=("Docker")
    fi

    if (( ${#caches[@]} == 0 )); then
        echo "No cache tools found."
        return 0
    fi

    local selected=()

    # Check for fzf (skip selection in quick mode - clean all)
    if $quick; then
        selected=("${labels[@]}")
    elif command -v fzf &>/dev/null || [[ -x "$BINARY_DIR/fzf" ]]; then
        # fzf multi-select mode
        local fzf_cmd="fzf"
        [[ -x "$BINARY_DIR/fzf" ]] && fzf_cmd="$BINARY_DIR/fzf"

        echo ""
        echo -e "\033[1m🧹 Cache Cleanup\033[0m"
        echo -e "\033[2mTab to select, Enter to confirm, Esc to cancel\033[0m"
        echo ""

        local result
        result=$(printf '%s\n' "${labels[@]}" | $fzf_cmd --multi --height=10 --reverse --prompt="Select caches: ")

        [[ -z "$result" ]] && { echo "Cancelled."; return 0; }

        while IFS= read -r line; do
            selected+=("$line")
        done <<< "$result"
    else
        # Fallback: show list, ask Y/n
        echo ""
        echo -e "\033[1m🧹 Cache Cleanup\033[0m"
        echo ""
        echo -e "\033[2mAvailable caches to clean:\033[0m"
        for label in "${labels[@]}"; do
            echo "  • $label"
        done
        echo ""
        echo -n "Clean all? [Y/n]: "
        read -r response

        if [[ "$response" =~ ^[nN] ]]; then
            echo "Cancelled."
            return 0
        fi

        selected=("${labels[@]}")
    fi

    # Clean selected caches
    local cleaned=0
    local quick_result=()

    if ! $quick; then
        echo ""
    fi

    for item in "${selected[@]}"; do
        case "$item" in
            Homebrew)
                if $quick; then
                    brew cleanup -q 2>/dev/null && quick_result+=("Homebrew ✓") || quick_result+=("Homebrew ✗")
                else
                    echo -e "\033[1;36m→ Homebrew\033[0m"
                    brew cleanup
                    echo ""
                fi
                ((cleaned++))
                ;;
            Composer)
                if $quick; then
                    (composer clear-cache 2>/dev/null || php "$BINARY_DIR/composer" clear-cache 2>/dev/null) && quick_result+=("Composer ✓") || quick_result+=("Composer ✗")
                else
                    echo -e "\033[1;36m→ Composer\033[0m"
                    composer clear-cache 2>/dev/null || php "$BINARY_DIR/composer" clear-cache 2>/dev/null
                    echo ""
                fi
                ((cleaned++))
                ;;
            npm)
                if $quick; then
                    npm cache clean --force &>/dev/null && quick_result+=("npm ✓") || quick_result+=("npm ✗")
                else
                    echo -e "\033[1;36m→ npm\033[0m"
                    npm cache clean --force
                    echo ""
                fi
                ((cleaned++))
                ;;
            yarn)
                if $quick; then
                    yarn cache clean &>/dev/null && quick_result+=("yarn ✓") || quick_result+=("yarn ✗")
                else
                    echo -e "\033[1;36m→ yarn\033[0m"
                    yarn cache clean
                    echo ""
                fi
                ((cleaned++))
                ;;
            pnpm)
                if $quick; then
                    pnpm store prune &>/dev/null && quick_result+=("pnpm ✓") || quick_result+=("pnpm ✗")
                else
                    echo -e "\033[1;36m→ pnpm\033[0m"
                    pnpm store prune
                    echo ""
                fi
                ((cleaned++))
                ;;
            bun)
                if $quick; then
                    bun pm cache rm &>/dev/null && quick_result+=("bun ✓") || quick_result+=("bun ✗")
                else
                    echo -e "\033[1;36m→ bun\033[0m"
                    bun pm cache rm
                    echo ""
                fi
                ((cleaned++))
                ;;
            pip)
                if $quick; then
                    pip3 cache purge &>/dev/null && quick_result+=("pip ✓") || quick_result+=("pip ✗")
                else
                    echo -e "\033[1;36m→ pip\033[0m"
                    pip3 cache purge
                    echo ""
                fi
                ((cleaned++))
                ;;
            Docker)
                if $quick; then
                    docker system prune -f &>/dev/null && quick_result+=("Docker ✓") || quick_result+=("Docker ✗")
                else
                    echo -e "\033[1;36m→ Docker\033[0m"
                    docker system prune -f
                    echo ""
                fi
                ((cleaned++))
                ;;
        esac
    done

    if $quick; then
        echo "🧹 $(IFS=' | '; echo "${quick_result[*]}")"
    else
        if (( cleaned > 0 )); then
            echo -e "\033[32m✓ Cleaned $cleaned cache(s)!\033[0m"
        else
            echo -e "\033[2mNo caches cleaned.\033[0m"
        fi

        # Show project cleanup info
        echo ""
        echo -e "\033[2m💡 To clean project dependencies (node_modules, .yarn, .pnpm-store, vendor, __pycache__):\033[0m"
        echo -e "\033[2m   project-cleanup ~/Projects     # scan & clean folder\033[0m"
        echo -e "\033[2m   project-cleanup -n ~/Projects  # dry run (preview)\033[0m"
    fi
}

# Show cache cleanup commands (only for installed tools)
cache-help() {
    echo ""
    echo -e "\033[1m🧹 Cache Cleanup Commands\033[0m"
    echo ""

    command -v brew &>/dev/null && echo -e "\033[2mHomebrew:\033[0m     brew cleanup"
    (command -v composer &>/dev/null || [[ -x "$BINARY_DIR/composer" ]]) && echo -e "\033[2mComposer:\033[0m     composer clear-cache"
    command -v npm &>/dev/null && echo -e "\033[2mnpm:\033[0m          npm cache clean --force"
    command -v yarn &>/dev/null && echo -e "\033[2myarn:\033[0m         yarn cache clean"
    command -v pnpm &>/dev/null && echo -e "\033[2mpnpm:\033[0m         pnpm store prune"
    command -v bun &>/dev/null && echo -e "\033[2mbun:\033[0m          bun pm cache rm"
    command -v pip3 &>/dev/null && echo -e "\033[2mpip:\033[0m          pip3 cache purge"
    (command -v docker &>/dev/null && docker info &>/dev/null 2>&1) && echo -e "\033[2mDocker:\033[0m       docker system prune -f"

    echo ""
    echo -e "\033[2mOr run:\033[0m       cache-cleanup     \033[2m(interactive, verbose)\033[0m"
    echo -e "              cache-cleanup -q  \033[2m(quick, clean all)\033[0m"
    echo ""
}

# Show cache cleanup reminder on load
echo -e "\033[2m"
echo "  🧹 Run cache-cleanup to clean caches | cache-help for commands"
echo -e "\033[0m"
