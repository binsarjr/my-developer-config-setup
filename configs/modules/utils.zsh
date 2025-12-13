# =============================================================================
# Directory Shortcuts
# =============================================================================
_reg ..    "cd .."                      "Navigate up 1 directory level"
_reg ...   "cd ../.."                   "Navigate up 2 directory levels"
_reg ....  "cd ../../.."                "Navigate up 3 directory levels"
_reg ..... "cd ../../../.."             "Navigate up 4 directory levels"

# =============================================================================
# Productivity Functions
# =============================================================================

# mkcd - create directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# backup - create timestamped backup
backup() { cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)" }

# extract - universal archive extractor
extract() {
    if [[ -f "$1" ]]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz)  tar xzf "$1" ;;
            *.tar.xz)  tar xJf "$1" ;;
            *.bz2)     bunzip2 "$1" ;;
            *.gz)      gunzip "$1" ;;
            *.tar)     tar xf "$1" ;;
            *.tbz2)    tar xjf "$1" ;;
            *.tgz)     tar xzf "$1" ;;
            *.zip)     unzip "$1" ;;
            *.Z)       uncompress "$1" ;;
            *.7z)      7z x "$1" ;;
            *.rar)     unrar x "$1" ;;
            *) echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =============================================================================
# Quick Utilities
# =============================================================================

# ports - show listening ports
ports() { lsof -i -P -n | grep LISTEN }

# myip - show public IP
myip() { curl -s ifconfig.me && echo "" }

# localip - show local IP
localip() { ipconfig getifaddr en0 }

# weather - show weather (optional city)
weather() { curl -s "wttr.in/${1:-}?format=3" }
