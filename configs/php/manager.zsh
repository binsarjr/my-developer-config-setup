# =============================================================================
# PHP Version Manager (Homebrew)
# Commands for managing PHP versions: install, switch, uninstall, cleanup
# =============================================================================

# Check if Homebrew is available
if ! command -v brew &>/dev/null; then
    return 0
fi

# =============================================================================
# Internal Helpers (DRY)
# =============================================================================

# Check if fzf is available
_php_has_fzf() {
    command -v fzf &>/dev/null || [[ -x "$BINARY_DIR/fzf" ]]
}

# Get fzf command path
_php_fzf_cmd() {
    if [[ -x "$BINARY_DIR/fzf" ]]; then
        echo "$BINARY_DIR/fzf"
    else
        echo "fzf"
    fi
}

# Get installed PHP versions
_php_get_installed() {
    brew list --formula | grep -E '^php(@[0-9.]+)?$' | sort -V
}

# Get available PHP versions from Homebrew
_php_get_available() {
    brew search '/^php(@[0-9.]+)?$/' 2>/dev/null | grep -E '^php(@[0-9.]+)?$' | sort -V
}

# Get current active PHP formula
_php_get_current_formula() {
    local php_path=$(which php 2>/dev/null)
    if [[ -z "$php_path" ]]; then
        echo ""
        return
    fi

    # Resolve symlink to find formula
    local real_path=$(readlink -f "$php_path" 2>/dev/null || greadlink -f "$php_path" 2>/dev/null)
    if [[ "$real_path" =~ php@([0-9.]+) ]]; then
        echo "php@${match[1]}"
    elif [[ "$real_path" =~ /php/ ]]; then
        echo "php"
    else
        echo ""
    fi
}

# Resolve version input to Homebrew formula
# "8.2" → "php@8.2", "8.4" or empty → "php" (latest)
_php_resolve_formula() {
    local ver="$1"
    if [[ -z "$ver" ]]; then
        echo "php"
    elif [[ "$ver" == "php" ]] || [[ "$ver" =~ ^php(@|$) ]]; then
        echo "$ver"
    else
        # Check if it's the latest version
        local latest=$(brew info php --json 2>/dev/null | grep -o '"versions":{[^}]*"stable":"[^"]*"' | grep -o '[0-9]\+\.[0-9]\+' | head -1)
        if [[ "$ver" == "$latest" ]] || [[ "$ver" == "${latest%.*}" ]]; then
            echo "php"
        else
            echo "php@$ver"
        fi
    fi
}

# =============================================================================
# User Commands
# =============================================================================

# Show current PHP version
php-current() {
    if ! command -v php &>/dev/null; then
        echo -e "\033[31m✗ PHP not found in PATH\033[0m"
        return 1
    fi

    local version=$(php -v | head -1)
    local formula=$(_php_get_current_formula)

    echo ""
    echo -e "\033[1m🐘 Current PHP\033[0m"
    echo -e "   Version:  \033[36m$version\033[0m"
    [[ -n "$formula" ]] && echo -e "   Formula:  \033[2m$formula\033[0m"
    echo -e "   Path:     \033[2m$(which php)\033[0m"
    echo ""
}

# List installed PHP versions
php-list() {
    local installed=$(_php_get_installed)
    local current=$(_php_get_current_formula)

    echo ""
    echo -e "\033[1m🐘 Installed PHP Versions\033[0m"
    echo ""

    if [[ -z "$installed" ]]; then
        echo -e "   \033[2mNo PHP versions installed via Homebrew\033[0m"
    else
        while IFS= read -r formula; do
            local ver=$(brew info "$formula" --json 2>/dev/null | grep -o '"pkg_version":"[^"]*"' | head -1 | cut -d'"' -f4)
            if [[ "$formula" == "$current" ]]; then
                echo -e "   \033[32m● $formula\033[0m \033[2m($ver) ← active\033[0m"
            else
                echo -e "   \033[2m○ $formula ($ver)\033[0m"
            fi
        done <<< "$installed"
    fi
    echo ""
}

# List available PHP versions
php-available() {
    local available=$(_php_get_available)
    local installed=$(_php_get_installed)

    echo ""
    echo -e "\033[1m🐘 Available PHP Versions (Homebrew)\033[0m"
    echo ""

    while IFS= read -r formula; do
        if echo "$installed" | grep -q "^${formula}$"; then
            echo -e "   \033[32m✓ $formula\033[0m \033[2m(installed)\033[0m"
        else
            echo -e "   \033[2m○ $formula\033[0m"
        fi
    done <<< "$available"
    echo ""
}

# Switch PHP version
php-switch() {
    local target="$1"

    # If no version specified, use fzf or prompt
    if [[ -z "$target" ]]; then
        local installed=$(_php_get_installed)
        local current=$(_php_get_current_formula)

        if [[ -z "$installed" ]]; then
            echo -e "\033[31m✗ No PHP versions installed\033[0m"
            return 1
        fi

        if _php_has_fzf; then
            echo ""
            echo -e "\033[1m🐘 Switch PHP Version\033[0m"
            target=$(echo "$installed" | $(_php_fzf_cmd) \
                --height=40% \
                --reverse \
                --border \
                --prompt="Select PHP version: " \
                --header="Current: $current")
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        else
            echo ""
            echo -e "\033[1m🐘 Installed PHP versions:\033[0m"
            echo "$installed" | while read -r f; do
                [[ "$f" == "$current" ]] && echo "  $f (current)" || echo "  $f"
            done
            echo ""
            echo -n "Enter version to switch (e.g., 8.2): "
            read -r target
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        fi
    fi

    local formula=$(_php_resolve_formula "$target")
    local current=$(_php_get_current_formula)

    # Check if formula is installed
    if ! brew list "$formula" &>/dev/null; then
        echo -e "\033[31m✗ $formula is not installed\033[0m"
        echo -e "\033[2m  Run: php-install $target\033[0m"
        return 1
    fi

    # Already active?
    if [[ "$formula" == "$current" ]]; then
        echo -e "\033[33m! $formula is already active\033[0m"
        return 0
    fi

    echo ""
    echo -e "\033[1m🐘 Switching PHP...\033[0m"

    # Unlink current
    if [[ -n "$current" ]]; then
        echo -e "   \033[2mUnlinking $current...\033[0m"
        brew unlink "$current" --quiet
    fi

    # Link new
    echo -e "   \033[2mLinking $formula...\033[0m"
    brew link "$formula" --overwrite --force --quiet

    # Verify
    local new_ver=$(php -v 2>/dev/null | head -1 | awk '{print $2}')
    echo ""
    echo -e "\033[32m✓ Switched to PHP $new_ver\033[0m"
    echo ""
}

# Install PHP version
php-install() {
    local target="$1"

    # If no version specified, use fzf or prompt
    if [[ -z "$target" ]]; then
        local available=$(_php_get_available)
        local installed=$(_php_get_installed)

        # Filter out already installed
        local not_installed=$(echo "$available" | while read -r f; do
            echo "$installed" | grep -q "^${f}$" || echo "$f"
        done)

        if [[ -z "$not_installed" ]]; then
            echo -e "\033[33m! All available PHP versions are already installed\033[0m"
            return 0
        fi

        if _php_has_fzf; then
            echo ""
            echo -e "\033[1m🐘 Install PHP Version\033[0m"
            target=$(echo "$not_installed" | $(_php_fzf_cmd) \
                --height=40% \
                --reverse \
                --border \
                --prompt="Select PHP version to install: ")
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        else
            echo ""
            echo -e "\033[1m🐘 Available PHP versions:\033[0m"
            echo "$not_installed"
            echo ""
            echo -n "Enter version to install (e.g., 8.2): "
            read -r target
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        fi
    fi

    local formula=$(_php_resolve_formula "$target")

    # Check if already installed
    if brew list "$formula" &>/dev/null; then
        echo -e "\033[33m! $formula is already installed\033[0m"
        return 0
    fi

    echo ""
    echo -e "\033[1m🐘 Installing $formula...\033[0m"
    echo ""

    brew install "$formula"

    if [[ $? -eq 0 ]]; then
        echo ""
        echo -e "\033[32m✓ $formula installed successfully\033[0m"
        echo -e "\033[2m  Run 'php-switch $target' to use it\033[0m"
        echo ""
    fi
}

# Uninstall PHP version
php-uninstall() {
    local target="$1"

    # If no version specified, use fzf or prompt
    if [[ -z "$target" ]]; then
        local installed=$(_php_get_installed)
        local current=$(_php_get_current_formula)

        if [[ -z "$installed" ]]; then
            echo -e "\033[31m✗ No PHP versions installed\033[0m"
            return 1
        fi

        if _php_has_fzf; then
            echo ""
            echo -e "\033[1m🐘 Uninstall PHP Version\033[0m"
            target=$(echo "$installed" | $(_php_fzf_cmd) \
                --height=40% \
                --reverse \
                --border \
                --prompt="Select PHP version to uninstall: " \
                --header="Current: $current (will be skipped)")
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        else
            echo ""
            echo -e "\033[1m🐘 Installed PHP versions:\033[0m"
            echo "$installed"
            echo ""
            echo -n "Enter version to uninstall (e.g., 8.1): "
            read -r target
            [[ -z "$target" ]] && { echo "Cancelled."; return 0; }
        fi
    fi

    local formula=$(_php_resolve_formula "$target")
    local current=$(_php_get_current_formula)

    # Prevent uninstalling current
    if [[ "$formula" == "$current" ]]; then
        echo -e "\033[31m✗ Cannot uninstall active PHP version\033[0m"
        echo -e "\033[2m  Switch to another version first: php-switch <version>\033[0m"
        return 1
    fi

    # Check if installed
    if ! brew list "$formula" &>/dev/null; then
        echo -e "\033[31m✗ $formula is not installed\033[0m"
        return 1
    fi

    echo ""
    echo -e "\033[1m🐘 Uninstalling $formula...\033[0m"
    echo ""

    brew uninstall "$formula"

    if [[ $? -eq 0 ]]; then
        echo ""
        echo -e "\033[32m✓ $formula uninstalled\033[0m"
        echo ""
    fi
}

# Cleanup old PHP versions
php-cleanup() {
    echo ""
    echo -e "\033[1m🐘 PHP Cleanup\033[0m"
    echo ""

    local installed=$(_php_get_installed)
    local current=$(_php_get_current_formula)
    local count=$(echo "$installed" | wc -l | tr -d ' ')

    echo -e "   Installed versions: $count"
    echo -e "   Active version: $current"
    echo ""

    # Cleanup brew cache for PHP
    echo -e "\033[2mCleaning Homebrew cache for PHP...\033[0m"
    brew cleanup php 2>/dev/null
    brew cleanup $(echo "$installed" | tr '\n' ' ') 2>/dev/null

    echo ""
    echo -e "\033[32m✓ Cleanup complete\033[0m"
    echo ""

    if [[ $count -gt 2 ]]; then
        echo -e "\033[2m💡 You have $count PHP versions. Consider uninstalling unused ones:\033[0m"
        echo -e "\033[2m   php-uninstall <version>\033[0m"
        echo ""
    fi
}

# List PHP extensions
php-extensions() {
    if ! command -v php &>/dev/null; then
        echo -e "\033[31m✗ PHP not found\033[0m"
        return 1
    fi

    echo ""
    echo -e "\033[1m🐘 PHP Extensions\033[0m"
    echo -e "\033[2m   PHP $(php -v | head -1 | awk '{print $2}')\033[0m"
    echo ""

    php -m | while read -r ext; do
        [[ -n "$ext" ]] && echo "   $ext"
    done

    echo ""
}

# Help command
php-help() {
    echo ""
    echo -e "\033[1m🐘 PHP Version Manager\033[0m"
    echo ""
    echo -e "  \033[36mphp-current\033[0m      Show current active PHP version"
    echo -e "  \033[36mphp-list\033[0m         List all installed PHP versions"
    echo -e "  \033[36mphp-available\033[0m    List available versions from Homebrew"
    echo -e "  \033[36mphp-switch\033[0m       Switch PHP version (fzf picker or specify)"
    echo -e "  \033[36mphp-install\033[0m      Install PHP version (fzf picker or specify)"
    echo -e "  \033[36mphp-uninstall\033[0m    Uninstall PHP version (fzf picker or specify)"
    echo -e "  \033[36mphp-cleanup\033[0m      Clean up Homebrew cache for PHP"
    echo -e "  \033[36mphp-extensions\033[0m   List installed PHP extensions"
    echo ""
    echo -e "  \033[2mExamples:\033[0m"
    echo -e "    php-switch 8.2      # Switch to PHP 8.2"
    echo -e "    php-switch          # Interactive picker (fzf)"
    echo -e "    php-install 8.3     # Install PHP 8.3"
    echo ""
}
