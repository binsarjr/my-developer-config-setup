# =============================================================================
# Alias Registry
# DRY alias definitions with descriptions, tags + fzf search
# =============================================================================

# Global registry: [name]="command|description|tags"
typeset -gA ALIAS_REGISTRY

# Register alias with description and tags
# Usage: _reg <name> <command> <description> [tags]
_reg() {
    local name=$1 cmd=$2 desc=$3 tags=${4:-}
    ALIAS_REGISTRY[$name]="$cmd|$desc|$tags"
    alias $name="$cmd"
}

# Register alias only if tool exists (for conditional tool aliases)
# Usage: _reg_if <tool> <name> <command> <description> [tags]
_reg_if() {
    local tool=$1 name=$2 cmd=$3 desc=$4 tags=${5:-}
    if _has_bin "$tool"; then
        ALIAS_REGISTRY[$name]="$cmd|$desc|$tags"
        alias $name="$cmd"
    fi
}

# List all registered aliases
alias-list() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: alias-list"
        echo "  List all registered aliases with descriptions"
        return 0
    }
    echo ""
    echo -e "\033[1m📋 Registered Aliases\033[0m"
    echo ""
    for name in ${(ko)ALIAS_REGISTRY}; do
        local entry="${ALIAS_REGISTRY[$name]}"
        local cmd="${entry%%|*}"
        local rest="${entry#*|}"
        local desc="${rest%%|*}"
        local tags="${rest#*|}"
        [[ "$tags" == "$desc" ]] && tags=""
        if [[ -n "$tags" ]]; then
            printf "  \033[36m%-12s\033[0m %-40s \033[2m[%s]\033[0m\n" "$name" "$desc" "$tags"
        else
            printf "  \033[36m%-12s\033[0m %s\n" "$name" "$desc"
        fi
    done
    echo ""
    echo -e "\033[2mTotal: ${#ALIAS_REGISTRY[@]} aliases | Use 'cheat' to search\033[0m"
    echo ""
}

# Search aliases with fzf (cheatsheet)
cheat() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: cheat [query]"
        echo "  Search aliases & commands interactively with fzf"
        echo "  Search by name, description, or tags (e.g. 'git', 'docker')"
        return 0
    }
    local fzf_cmd="fzf"
    [[ -x "$BINARY_DIR/fzf" ]] && fzf_cmd="$BINARY_DIR/fzf"

    if ! command -v fzf &>/dev/null && [[ ! -x "$BINARY_DIR/fzf" ]]; then
        echo "fzf not found. Run 'alias-list' to see all aliases."
        return 1
    fi

    # Build list: "name | description | tags"
    local list=""
    for name in ${(ko)ALIAS_REGISTRY}; do
        local entry="${ALIAS_REGISTRY[$name]}"
        local cmd="${entry%%|*}"
        local rest="${entry#*|}"
        local desc="${rest%%|*}"
        local tags="${rest#*|}"
        [[ "$tags" == "$desc" ]] && tags=""
        if [[ -n "$tags" ]]; then
            list+="$(printf "%-12s │ %-40s │ %s" "$name" "$desc" "$tags")\n"
        else
            list+="$(printf "%-12s │ %s" "$name" "$desc")\n"
        fi
    done

    # fzf selection with preview
    local selected
    selected=$(echo -e "$list" | $fzf_cmd \
        --query="$*" \
        --exact \
        --height=50% \
        --reverse \
        --border \
        --prompt="🔍 Search alias: " \
        --header="Tab: select | Enter: show info | Esc: cancel" \
        --preview='
            name=$(echo {} | cut -d"│" -f1 | xargs)
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  Alias:   $name"
        ' \
        --preview-window=down:5:wrap)

    [[ -z "$selected" ]] && return

    # Extract command from selection
    local name=$(echo "$selected" | cut -d'│' -f1 | xargs)
    local entry="${ALIAS_REGISTRY[$name]}"
    local cmd="${entry%%|*}"
    local rest="${entry#*|}"
    local desc="${rest%%|*}"
    local tags="${rest#*|}"
    [[ "$tags" == "$desc" ]] && tags=""

    # Show detailed info
    echo ""
    echo -e "\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "  \033[1mAlias:\033[0m   \033[36m$name\033[0m"
    echo -e "  \033[1mCommand:\033[0m $cmd"
    echo -e "  \033[1mDesc:\033[0m    $desc"
    [[ -n "$tags" ]] && echo -e "  \033[1mTags:\033[0m    \033[33m$tags\033[0m"
    echo -e "\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""

    # Put command in buffer for editing (with trailing space for args)
    print -z "$cmd "
}

