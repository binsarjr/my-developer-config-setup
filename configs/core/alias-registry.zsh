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

# =============================================================================
# Cheat - Interactive Cheatsheet (cheatshh-like)
# =============================================================================

# Custom cheatsheets storage (separate from ALIAS_REGISTRY)
typeset -gA CUSTOM_CHEATSHEETS
CHEATSHEET_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/cheatsheets"

# Load custom cheatsheets from files
_cheat_load_custom() {
    CUSTOM_CHEATSHEETS=()
    [[ ! -d "$CHEATSHEET_DIR" ]] && return

    local file group name desc cmd
    for file in "$CHEATSHEET_DIR"/*.txt(N); do
        [[ ! -f "$file" ]] && continue
        group="${${file:t}%.txt}"

        local in_entry=false current_name="" current_desc="" current_cmd=""
        while IFS= read -r line || [[ -n "$line" ]]; do
            if [[ "$line" =~ ^#\ (.+)$ ]]; then
                # Save previous entry
                if [[ -n "$current_name" ]]; then
                    CUSTOM_CHEATSHEETS[$current_name]="$current_cmd|$current_desc|$group"
                fi
                current_name="${match[1]}"
                current_desc=""
                current_cmd=""
                in_entry=true
            elif [[ "$line" == "---" ]]; then
                # Entry separator - save current
                if [[ -n "$current_name" ]]; then
                    CUSTOM_CHEATSHEETS[$current_name]="$current_cmd|$current_desc|$group"
                fi
                current_name=""
                in_entry=false
            elif $in_entry; then
                if [[ -z "$current_desc" ]]; then
                    current_desc="$line"
                else
                    [[ -n "$current_cmd" ]] && current_cmd+=$'\n'
                    current_cmd+="$line"
                fi
            fi
        done < "$file"
        # Save last entry
        if [[ -n "$current_name" ]]; then
            CUSTOM_CHEATSHEETS[$current_name]="$current_cmd|$current_desc|$group"
        fi
    done
}

# Get fzf command
_cheat_fzf() {
    if [[ -x "$BINARY_DIR/fzf" ]]; then
        echo "$BINARY_DIR/fzf"
    elif command -v fzf &>/dev/null; then
        echo "fzf"
    else
        return 1
    fi
}

# Build combined list from aliases + custom
_cheat_build_list() {
    local list="" name entry cmd rest desc tags source

    # Aliases
    for name in ${(ko)ALIAS_REGISTRY}; do
        entry="${ALIAS_REGISTRY[$name]}"
        cmd="${entry%%|*}"
        rest="${entry#*|}"
        desc="${rest%%|*}"
        tags="${rest#*|}"
        [[ "$tags" == "$desc" ]] && tags=""
        list+="$(printf "%-14s │ %-38s │ %-12s │ %s" "$name" "$desc" "${tags:-—}" "alias")\n"
    done

    # Custom cheatsheets
    _cheat_load_custom
    for name in ${(ko)CUSTOM_CHEATSHEETS}; do
        entry="${CUSTOM_CHEATSHEETS[$name]}"
        cmd="${entry%%|*}"
        rest="${entry#*|}"
        desc="${rest%%|*}"
        tags="${rest#*|}"
        [[ "$tags" == "$desc" ]] && tags=""
        list+="$(printf "%-14s │ %-38s │ %-12s │ %s" "$name" "$desc" "${tags:-—}" "custom")\n"
    done

    echo -e "$list"
}

# Show tldr for command
_cheat_tldr() {
    local cmd="$1"
    if command -v tldr &>/dev/null; then
        tldr "$cmd" 2>/dev/null || echo "No tldr entry for '$cmd'"
    else
        echo "tldr not installed. Install: brew install tldr"
    fi
}

# Show man page for command
_cheat_man() {
    local cmd="$1"
    man "$cmd" 2>/dev/null || echo "No man page for '$cmd'"
}

# Main search function
_cheat_search() {
    local fzf_cmd
    fzf_cmd=$(_cheat_fzf) || { echo "fzf not found. Run 'alias-list' to see all aliases."; return 1; }

    local list=$(_cheat_build_list)

    # Transform query: "docker stop" → "'docker 'stop" (exact per-word)
    local query=""
    if [[ -n "$*" ]]; then
        for word in $@; do
            query+="'$word "
        done
    fi

    # fzf with key bindings
    local selected
    selected=$(echo -e "$list" | $fzf_cmd \
        --query="$query" \
        --height=60% \
        --reverse \
        --border \
        --prompt="🔍 Search: " \
        --header=$'Search: \'exact ^prefix suffix$ !exclude\nEnter: select | Ctrl-T: tldr | Ctrl-M: man | Ctrl-G: groups' \
        --preview='
            name=$(echo {} | cut -d"│" -f1 | xargs)
            source=$(echo {} | rev | cut -d"│" -f1 | rev | xargs)
            echo ""
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "  Name:   $name"
            echo "  Source: $source"
        ' \
        --preview-window=down:6:wrap \
        --bind="ctrl-t:execute(command -v tldr &>/dev/null && tldr {1} 2>/dev/null | less || echo 'tldr not installed')" \
        --bind="ctrl-m:execute(man {1} 2>/dev/null || echo 'No man page')")

    [[ -z "$selected" ]] && return

    # Extract info from selection
    local name=$(echo "$selected" | cut -d'│' -f1 | xargs)
    local source=$(echo "$selected" | rev | cut -d'│' -f1 | rev | xargs)

    local entry cmd rest desc tags
    if [[ "$source" == "alias" ]]; then
        entry="${ALIAS_REGISTRY[$name]}"
    else
        entry="${CUSTOM_CHEATSHEETS[$name]}"
    fi

    cmd="${entry%%|*}"
    rest="${entry#*|}"
    desc="${rest%%|*}"
    tags="${rest#*|}"
    [[ "$tags" == "$desc" ]] && tags=""

    # Show detailed info
    echo ""
    echo -e "\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "  \033[1mName:\033[0m    \033[36m$name\033[0m"
    echo -e "  \033[1mCommand:\033[0m $cmd"
    echo -e "  \033[1mDesc:\033[0m    $desc"
    [[ -n "$tags" ]] && echo -e "  \033[1mGroup:\033[0m   \033[33m$tags\033[0m"
    echo -e "  \033[1mSource:\033[0m  $source"
    echo -e "\033[2m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""

    # Put command in buffer
    print -z "$cmd "
}

# Browse by group/tag
_cheat_groups() {
    local fzf_cmd
    fzf_cmd=$(_cheat_fzf) || { echo "fzf not found."; return 1; }

    # Collect all unique tags/groups
    local tags_list="" entry rest tags
    for name in ${(ko)ALIAS_REGISTRY}; do
        entry="${ALIAS_REGISTRY[$name]}"
        rest="${entry#*|}"
        tags="${rest#*|}"
        [[ "$tags" != "${rest%%|*}" && -n "$tags" ]] && {
            for tag in ${(s:,:)tags}; do
                tags_list+="$tag\n"
            done
        }
    done

    _cheat_load_custom
    for name in ${(ko)CUSTOM_CHEATSHEETS}; do
        entry="${CUSTOM_CHEATSHEETS[$name]}"
        rest="${entry#*|}"
        tags="${rest#*|}"
        [[ "$tags" != "${rest%%|*}" && -n "$tags" ]] && tags_list+="$tags\n"
    done

    # Get unique sorted tags
    local selected_group
    selected_group=$(echo -e "$tags_list" | sort -u | $fzf_cmd \
        --height=40% \
        --reverse \
        --border \
        --prompt="📁 Select group: " \
        --header="Select a group to browse")

    [[ -z "$selected_group" ]] && return

    # Search with selected group
    _cheat_search "$selected_group"
}

# Add new custom cheatsheet entry
_cheat_add() {
    mkdir -p "$CHEATSHEET_DIR"

    echo -e "\033[1m📝 Add Custom Cheatsheet Entry\033[0m"
    echo ""

    # Get group (file name)
    echo -n "Group (e.g. docker, git, misc): "
    read group
    [[ -z "$group" ]] && group="misc"

    # Get entry details
    echo -n "Name (short identifier): "
    read name
    [[ -z "$name" ]] && { echo "Name required."; return 1; }

    echo -n "Description: "
    read desc

    echo "Command/Note (press Ctrl-D when done):"
    local cmd=$(cat)

    # Append to file
    local file="$CHEATSHEET_DIR/$group.txt"
    {
        echo ""
        echo "# $name"
        echo "$desc"
        echo "$cmd"
        echo "---"
    } >> "$file"

    echo ""
    echo -e "\033[32m✓ Added '$name' to $group\033[0m"
}

# Edit custom cheatsheets
_cheat_edit() {
    mkdir -p "$CHEATSHEET_DIR"

    local editor="${EDITOR:-nano}"
    if [[ -n "$1" ]]; then
        # Edit specific group
        $editor "$CHEATSHEET_DIR/$1.txt"
    else
        # List groups and pick
        local fzf_cmd
        fzf_cmd=$(_cheat_fzf)

        if [[ -n "$fzf_cmd" ]] && [[ -d "$CHEATSHEET_DIR" ]]; then
            local files=$(ls "$CHEATSHEET_DIR"/*.txt 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/\.txt$//')
            if [[ -n "$files" ]]; then
                local selected=$(echo "$files" | $fzf_cmd --prompt="Edit group: ")
                [[ -n "$selected" ]] && $editor "$CHEATSHEET_DIR/$selected.txt"
            else
                echo "No cheatsheets yet. Create one with: cheat -a"
            fi
        else
            echo "Cheatsheet dir: $CHEATSHEET_DIR"
            echo "Edit directly or use: cheat -a"
        fi
    fi
}

# Help
_cheat_help() {
    cat << 'EOF'
Usage: cheat [options] [query]

Options:
  -g, --groups    Browse by group/tag first
  -a, --add       Add new custom cheatsheet entry
  -e, --edit      Edit custom cheatsheets
  -h, --help      Show this help

Examples:
  cheat              Search all (aliases + custom)
  cheat docker       Search for 'docker'
  cheat -g           Browse by group
  cheat -a           Add new entry
  cheat -e docker    Edit docker cheatsheet

Key bindings (in fzf):
  Enter     Select and show info
  Ctrl-T    View tldr page
  Ctrl-M    View man page

Search syntax:
  'word     Exact match
  ^word     Starts with
  word$     Ends with
  !word     Exclude

Custom cheatsheets: ~/.config/cheatsheets/*.txt
EOF
}

# Main cheat function
cheat() {
    case "$1" in
        -g|--groups) _cheat_groups ;;
        -a|--add)    _cheat_add ;;
        -e|--edit)   shift; _cheat_edit "$@" ;;
        -h|--help)   _cheat_help ;;
        *)           _cheat_search "$@" ;;
    esac
}

# Register core commands
_reg cheat      "cheat"      "Search commands (cheatsheet)" "help,search,cheat"
_reg alias-list "alias-list" "List all registered aliases" "help,alias"

