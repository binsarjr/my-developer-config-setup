#!/bin/bash
input=$(cat)

# Extract values from JSON (all available Claude Code statusLine fields)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""')
model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
model_id=$(echo "$input" | jq -r '.model.id // ""')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
version=$(echo "$input" | jq -r '.version // ""')
session_id=$(echo "$input" | jq -r '.session_id // ""')

# Cost information
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
total_duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
api_duration_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // 0')

# Context window
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
total_input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
usage=$(echo "$input" | jq '.context_window.current_usage // null')
context_pct=0
if [ "$usage" != "null" ]; then
    input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
    cache_create=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
    cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
    current=$((input_tokens + cache_create + cache_read))
    if [ "$context_size" != "0" ] && [ "$context_size" != "null" ]; then
        context_pct=$((current * 100 / context_size))
    fi
fi

# Check thinking mode from settings file
thinking_enabled="false"
settings_file="$HOME/.claude/settings.json"
if [ -f "$settings_file" ]; then
    thinking_enabled=$(jq -r '.alwaysThinkingEnabled // false' "$settings_file" 2>/dev/null || echo "false")
fi

# ANSI Color codes
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"

# Colors
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

# Bright colors
BRIGHT_RED="\033[91m"
BRIGHT_GREEN="\033[92m"
BRIGHT_YELLOW="\033[93m"
BRIGHT_BLUE="\033[94m"
BRIGHT_MAGENTA="\033[95m"
BRIGHT_CYAN="\033[96m"

# Directory display with git-aware path shortening
dir_display() {
    local dir="$1"
    if git -C "$dir" rev-parse --show-toplevel &>/dev/null 2>&1; then
        local repo_root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
        local rel_path="${dir#$repo_root}"
        if [[ -z "$rel_path" ]]; then
            basename "$repo_root"
        else
            echo "$(basename "$repo_root")$rel_path"
        fi
    else
        echo "$dir" | awk -F'/' '{ n = NF; if (n <= 3) print $0; else printf ".../%s/%s/%s", $(n-2), $(n-1), $n }'
    fi
}

# Git information with status indicators
git_info() {
    local dir="$1"
    if ! git -C "$dir" rev-parse --git-dir &>/dev/null 2>&1; then
        return
    fi

    local branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
    local indicators=""

    # Check for uncommitted changes
    if ! git -C "$dir" diff-index --quiet HEAD -- 2>/dev/null; then
        indicators="${indicators}${BRIGHT_YELLOW}*${RESET}"
    fi

    # Check for untracked files
    if [[ -n $(git -C "$dir" ls-files --others --exclude-standard 2>/dev/null) ]]; then
        indicators="${indicators}${BRIGHT_RED}?${RESET}"
    fi

    # Check for staged changes
    if ! git -C "$dir" diff-index --quiet --cached HEAD -- 2>/dev/null; then
        indicators="${indicators}${BRIGHT_GREEN}+${RESET}"
    fi

    # Check for ahead/behind
    local upstream=$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    local ahead_behind=""
    if [[ -n "$upstream" ]]; then
        local ahead=$(git -C "$dir" rev-list --count HEAD@{u}..HEAD 2>/dev/null || echo "0")
        local behind=$(git -C "$dir" rev-list --count HEAD..HEAD@{u} 2>/dev/null || echo "0")
        if [[ "$ahead" -gt 0 ]]; then
            ahead_behind="${ahead_behind}${GREEN}↑${ahead}${RESET}"
        fi
        if [[ "$behind" -gt 0 ]]; then
            ahead_behind="${ahead_behind}${RED}↓${behind}${RESET}"
        fi
    fi

    if [[ -n "$branch" ]]; then
        printf "${DIM}git:(${RESET}${BRIGHT_MAGENTA}%s${RESET}" "$branch"
        if [[ -n "$indicators" ]]; then
            printf " %b" "$indicators"
        fi
        if [[ -n "$ahead_behind" ]]; then
            printf " %b" "$ahead_behind"
        fi
        printf "${DIM})${RESET}"
    fi
}

# Model color based on type
get_model_display() {
    local name="$1"
    local id="$2"

    if [[ "$id" == *"opus"* ]] || [[ "$name" == *"Opus"* ]]; then
        printf "${BOLD}${BRIGHT_MAGENTA}%s${RESET}" "$name"
    elif [[ "$id" == *"sonnet"* ]] || [[ "$name" == *"Sonnet"* ]]; then
        printf "${BOLD}${BRIGHT_BLUE}%s${RESET}" "$name"
    elif [[ "$id" == *"haiku"* ]] || [[ "$name" == *"Haiku"* ]]; then
        printf "${BOLD}${BRIGHT_GREEN}%s${RESET}" "$name"
    else
        printf "${BOLD}${WHITE}%s${RESET}" "$name"
    fi
}

# Thinking mode display (from settings)
get_thinking_display() {
    local enabled="$1"

    if [[ "$enabled" == "true" ]]; then
        printf "${BOLD}${CYAN}THINK${RESET}"
    else
        printf "${DIM}no-think${RESET}"
    fi
}

# Context percentage with color coding
get_context_display() {
    local pct="$1"

    if [[ "$pct" -ge 80 ]]; then
        printf "${BOLD}${BRIGHT_RED}%d%%${RESET}" "$pct"
    elif [[ "$pct" -ge 60 ]]; then
        printf "${BOLD}${BRIGHT_YELLOW}%d%%${RESET}" "$pct"
    elif [[ "$pct" -ge 40 ]]; then
        printf "${YELLOW}%d%%${RESET}" "$pct"
    else
        printf "${GREEN}%d%%${RESET}" "$pct"
    fi
}

# Cost display with color
get_cost_display() {
    local cost="$1"

    if [[ "$cost" == "0" ]] || [[ "$cost" == "null" ]] || [[ -z "$cost" ]]; then
        return
    fi

    local formatted=$(printf "%.4f" "$cost" 2>/dev/null || echo "$cost")

    if (( $(echo "$cost >= 1" | bc -l 2>/dev/null || echo "0") )); then
        printf "${BOLD}${BRIGHT_RED}\$%s${RESET}" "$formatted"
    elif (( $(echo "$cost >= 0.1" | bc -l 2>/dev/null || echo "0") )); then
        printf "${BRIGHT_YELLOW}\$%s${RESET}" "$formatted"
    else
        printf "${GREEN}\$%s${RESET}" "$formatted"
    fi
}

# Lines changed display
get_lines_display() {
    local added="$1"
    local removed="$2"

    if [[ "$added" == "0" || "$added" == "null" ]] && [[ "$removed" == "0" || "$removed" == "null" ]]; then
        return
    fi

    local result=""
    if [[ "$added" != "0" ]] && [[ "$added" != "null" ]]; then
        result="${BRIGHT_GREEN}+${added}${RESET}"
    fi
    if [[ "$removed" != "0" ]] && [[ "$removed" != "null" ]]; then
        if [[ -n "$result" ]]; then
            result="${result}${DIM}/${RESET}"
        fi
        result="${result}${BRIGHT_RED}-${removed}${RESET}"
    fi
    printf "%b" "$result"
}

# Duration display (ms to human readable)
format_duration() {
    local ms="$1"

    if [[ "$ms" == "0" ]] || [[ "$ms" == "null" ]] || [[ -z "$ms" ]]; then
        return
    fi

    local seconds=$((ms / 1000))
    local minutes=$((seconds / 60))
    local hours=$((minutes / 60))

    if [[ "$hours" -gt 0 ]]; then
        printf "${BRIGHT_CYAN}%dh%dm${RESET}" "$hours" "$((minutes % 60))"
    elif [[ "$minutes" -gt 0 ]]; then
        printf "${CYAN}%dm%ds${RESET}" "$minutes" "$((seconds % 60))"
    else
        printf "${DIM}%ds${RESET}" "$seconds"
    fi
}

# Token count display (with K/M suffix)
format_tokens() {
    local tokens="$1"
    local label="$2"
    local color="$3"

    if [[ "$tokens" == "0" ]] || [[ "$tokens" == "null" ]] || [[ -z "$tokens" ]]; then
        return
    fi

    if [[ "$tokens" -ge 1000000 ]]; then
        printf "${color}%s%.1fM${RESET}" "$label" "$(echo "scale=1; $tokens/1000000" | bc)"
    elif [[ "$tokens" -ge 1000 ]]; then
        printf "${color}%s%.1fK${RESET}" "$label" "$(echo "scale=1; $tokens/1000" | bc)"
    else
        printf "${color}%s%d${RESET}" "$label" "$tokens"
    fi
}

# Version display
get_version_display() {
    local ver="$1"

    if [[ -z "$ver" ]] || [[ "$ver" == "null" ]]; then
        return
    fi

    printf "${DIM}v%s${RESET}" "$ver"
}

# Session ID display (short)
get_session_display() {
    local sid="$1"

    if [[ -z "$sid" ]] || [[ "$sid" == "null" ]]; then
        return
    fi

    # Show first 8 characters
    printf "${DIM}#%s${RESET}" "${sid:0:8}"
}

# Build components
dir_out=$(dir_display "$cwd")
git_out=$(git_info "$cwd")
model_out=$(get_model_display "$model_name" "$model_id")
thinking_out=$(get_thinking_display "$thinking_enabled")
context_out=$(get_context_display "$context_pct")
cost_out=$(get_cost_display "$total_cost")
lines_out=$(get_lines_display "$lines_added" "$lines_removed")
duration_out=$(format_duration "$total_duration_ms")
api_duration_out=$(format_duration "$api_duration_ms")
input_tokens_out=$(format_tokens "$total_input_tokens" "in:" "${BRIGHT_BLUE}")
output_tokens_out=$(format_tokens "$total_output_tokens" "out:" "${BRIGHT_GREEN}")
version_out=$(get_version_display "$version")
session_out=$(get_session_display "$session_id")

# ═══════════════════════════════════════════════════════════════
# ASSEMBLE STATUS LINE
# Format: [Model] [Think] [Style] dir git [lines] [tokens] [cost] [time] [ctx%] [ver] [session]
# ═══════════════════════════════════════════════════════════════

# Model
printf "${DIM}[${RESET}%b${DIM}]${RESET} " "$model_out"

# Thinking mode
printf "${DIM}[${RESET}%b${DIM}]${RESET} " "$thinking_out"

# Output style (if not default)
if [[ "$output_style" != "default" && "$output_style" != "null" && -n "$output_style" ]]; then
    printf "${DIM}[${RESET}${BRIGHT_CYAN}%s${RESET}${DIM}]${RESET} " "$output_style"
fi

# Directory
printf "${BOLD}${BRIGHT_CYAN}%s${RESET}" "$dir_out"

# Git info
if [[ -n "$git_out" ]]; then
    printf " %b" "$git_out"
fi

# Lines changed
if [[ -n "$lines_out" ]]; then
    printf " ${DIM}[${RESET}%b${DIM}]${RESET}" "$lines_out"
fi

# Tokens (input/output)
if [[ -n "$input_tokens_out" ]] || [[ -n "$output_tokens_out" ]]; then
    printf " ${DIM}[${RESET}"
    if [[ -n "$input_tokens_out" ]]; then
        printf "%b" "$input_tokens_out"
    fi
    if [[ -n "$input_tokens_out" ]] && [[ -n "$output_tokens_out" ]]; then
        printf " "
    fi
    if [[ -n "$output_tokens_out" ]]; then
        printf "%b" "$output_tokens_out"
    fi
    printf "${DIM}]${RESET}"
fi

# Cost
if [[ -n "$cost_out" ]]; then
    printf " ${DIM}[${RESET}%b${DIM}]${RESET}" "$cost_out"
fi

# Duration (session time)
if [[ -n "$duration_out" ]]; then
    printf " ${DIM}[${RESET}⏱ %b${DIM}]${RESET}" "$duration_out"
fi

# Context percentage
printf " ${DIM}[${RESET}ctx:%b${DIM}]${RESET}" "$context_out"

# Version
if [[ -n "$version_out" ]]; then
    printf " %b" "$version_out"
fi

# Session ID (short)
if [[ -n "$session_out" ]]; then
    printf " %b" "$session_out"
fi
