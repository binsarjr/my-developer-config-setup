# Shell Configuration
# Source this file from .zshrc:
#   source "/path/to/your/configs/config.zsh"
#
# Paths are auto-detected from script location.
# Override if needed:
#   CONFIG_DIR="/custom/path" source "/path/to/configs/config.zsh"

# Auto-detect CONFIG_DIR from sourced script location
# ${0:A:h} = absolute path to directory of this script (zsh)
if [[ -n "${CONFIG_DIR:-}" ]]; then
    : # User explicitly set CONFIG_DIR, use it
else
    CONFIG_DIR="${0:A:h}"
fi

# BINARY_DIR is sibling to configs folder (../binary-files)
BINARY_DIR="${BINARY_DIR:-${CONFIG_DIR:h}/binary-files}"

# Add to PATH
export PATH="$PATH:$BINARY_DIR:$CONFIG_DIR"

# =============================================================================
# Version Check
# =============================================================================
# Require zsh 5.0+ for associative arrays and advanced parameter expansion
_config_check_zsh_version() {
    local required_major=5
    local current_version="${ZSH_VERSION:-0.0}"

    # Parse major version: "5.8.1" -> 5
    local major="${current_version%%.*}"
    major=${major//[^0-9]/}
    [[ -z "$major" ]] && major=0

    if (( major < required_major )); then
        echo -e "\033[33m[configs]\033[0m Warning: zsh $ZSH_VERSION detected, requires $required_major.0+"
        echo -e "  Some features may not work correctly (associative arrays, etc.)"
        echo -e "  Upgrade: brew install zsh && chsh -s \$(which zsh)"
        echo ""
    fi
}
_config_check_zsh_version
unset -f _config_check_zsh_version

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
# Source Modules
# =============================================================================
# Order matters:
# 1. core (alias-registry defines _reg function)
# 2. tools, git, php, bun, utils (use _reg)
# 3. shell (help, welcome)
# 4. maintenance (cache-cleanup)
for module in \
    "$CONFIG_DIR/core/alias-registry.zsh" \
    "$CONFIG_DIR/tools/config.zsh" \
    "$CONFIG_DIR/docker/aliases.zsh" \
    "$CONFIG_DIR/git/aliases.zsh" \
    "$CONFIG_DIR/php/aliases.zsh" \
    "$CONFIG_DIR/php/manager.zsh" \
    "$CONFIG_DIR/bun/aliases.zsh" \
    "$CONFIG_DIR/utils/shortcuts.zsh" \
    "$CONFIG_DIR/utils/project-analyze.zsh" \
    "$CONFIG_DIR/utils/rsync.zsh" \
    "$CONFIG_DIR/shell/help.zsh" \
    "$CONFIG_DIR/shell/welcome.zsh" \
    "$CONFIG_DIR/maintenance/cache-cleanup.zsh"
do
    [[ -f "$module" ]] && source "$module"
done
