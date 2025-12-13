# =============================================================================
# Project Analysis
# =============================================================================

# Analyze project and provide recommendations
# Usage: project-analyze [directory]
project-analyze() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: project-analyze [directory]"
        echo ""
        echo "  project-analyze           Analyze current directory"
        echo "  project-analyze ~/app     Analyze specific directory"
        echo "  project-analyze -h        Show this help"
        echo ""
        echo "Detects: Node.js (npm/yarn/pnpm/bun), Laravel"
        echo "Recommends: bun for JS projects, Docker for Laravel"
        return 0
    }

    local dir="${1:-.}"

    # Validate directory
    if [[ ! -d "$dir" ]]; then
        echo -e "\033[31mError: Directory '$dir' does not exist.\033[0m"
        return 1
    fi

    dir=$(cd "$dir" && pwd)  # Get absolute path

    echo ""
    echo -e "\033[1m📊 Project Analysis: $dir\033[0m"
    echo ""

    local has_detections=false
    local has_recommendations=false
    local recommendations=()

    # ==========================================================================
    # Detection Phase
    # ==========================================================================
    echo -e "\033[1mDetected:\033[0m"

    # --- Node.js Detection ---
    local node_pm=""
    if [[ -f "$dir/package.json" ]]; then
        has_detections=true

        if [[ -f "$dir/bun.lockb" ]]; then
            node_pm="bun"
            echo -e "  \033[32m✓\033[0m Node.js project (using bun)"
        elif [[ -f "$dir/package-lock.json" ]]; then
            node_pm="npm"
            echo -e "  \033[32m✓\033[0m Node.js project (using npm)"
        elif [[ -f "$dir/yarn.lock" ]]; then
            node_pm="yarn"
            echo -e "  \033[32m✓\033[0m Node.js project (using yarn)"
        elif [[ -f "$dir/pnpm-lock.yaml" ]]; then
            node_pm="pnpm"
            echo -e "  \033[32m✓\033[0m Node.js project (using pnpm)"
        else
            echo -e "  \033[32m✓\033[0m Node.js project (no lockfile)"
        fi
    fi

    # --- Laravel Detection ---
    local is_laravel=false
    if [[ -f "$dir/artisan" ]]; then
        has_detections=true
        is_laravel=true
        echo -e "  \033[32m✓\033[0m Laravel project (artisan)"
    elif [[ -f "$dir/composer.json" ]] && grep -q "laravel/framework" "$dir/composer.json" 2>/dev/null; then
        has_detections=true
        is_laravel=true
        echo -e "  \033[32m✓\033[0m Laravel project (composer.json)"
    fi

    # --- No detections ---
    if ! $has_detections; then
        echo -e "  \033[2m(no supported project type detected)\033[0m"
        echo ""
        return 0
    fi

    # ==========================================================================
    # Recommendations Phase
    # ==========================================================================
    echo ""
    echo -e "\033[1m💡 Recommendations:\033[0m"

    # --- Recommend Bun ---
    if [[ -n "$node_pm" && "$node_pm" != "bun" ]]; then
        has_recommendations=true
        echo ""
        echo -e "  \033[33m→\033[0m Consider switching from \033[1m$node_pm\033[0m to \033[1mbun\033[0m for faster installs"
        echo -e "    \033[2mMigration:\033[0m"
        case "$node_pm" in
            npm)
                echo -e "    \033[36mrm -rf node_modules package-lock.json && bun install\033[0m"
                ;;
            yarn)
                echo -e "    \033[36mrm -rf node_modules yarn.lock && bun install\033[0m"
                ;;
            pnpm)
                echo -e "    \033[36mrm -rf node_modules pnpm-lock.yaml && bun install\033[0m"
                ;;
        esac
    fi

    # --- Recommend Docker for Laravel ---
    if $is_laravel; then
        has_recommendations=true
        echo ""
        echo -e "  \033[33m→\033[0m Consider using \033[1mDocker\033[0m for Laravel development"
        echo -e "    \033[2mBenefits: Consistent PHP version, easy database setup, isolated environment\033[0m"
        echo -e "    \033[2mOptions:\033[0m"
        echo -e "    \033[36m• Laravel Sail (official): composer require laravel/sail --dev\033[0m"
        echo -e "    \033[36m• Custom docker-compose with PHP, MySQL/PostgreSQL, Redis\033[0m"
    fi

    # --- No recommendations ---
    if ! $has_recommendations; then
        echo -e "  \033[32m✓\033[0m No recommendations - project setup looks good!"
    fi

    echo ""
}

# Register command
_reg project-analyze "project-analyze" "Analyze project & recommend tools" "util,project"
