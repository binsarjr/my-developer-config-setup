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
# 2. tools, git, php, utils (use _reg)
# 3. shell (help, welcome)
# 4. maintenance (cache-cleanup)
for module in \
    "$CONFIG_DIR/core/alias-registry.zsh" \
    "$CONFIG_DIR/tools/config.zsh" \
    "$CONFIG_DIR/git/aliases.zsh" \
    "$CONFIG_DIR/php/aliases.zsh" \
    "$CONFIG_DIR/php/manager.zsh" \
    "$CONFIG_DIR/utils/shortcuts.zsh" \
    "$CONFIG_DIR/shell/help.zsh" \
    "$CONFIG_DIR/shell/welcome.zsh" \
    "$CONFIG_DIR/maintenance/cache-cleanup.zsh"
do
    [[ -f "$module" ]] && source "$module"
done
