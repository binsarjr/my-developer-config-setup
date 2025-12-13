# =============================================================================
# Directory Shortcuts
# =============================================================================
_reg ..    "cd .."                      "Navigate up 1 directory level" "nav,cd"
_reg ...   "cd ../.."                   "Navigate up 2 directory levels" "nav,cd"
_reg ....  "cd ../../.."                "Navigate up 3 directory levels" "nav,cd"
_reg ..... "cd ../../../.."             "Navigate up 4 directory levels" "nav,cd"

# =============================================================================
# Productivity Functions
# =============================================================================

# mkcd - create directory and cd into it
mkcd() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: mkcd <directory>"
        echo "  Create directory and cd into it"
        return 0
    }
    mkdir -p "$1" && cd "$1"
}

# backup - create timestamped backup
backup() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: backup <file>"
        echo "  Create timestamped backup (file.bak.YYYYMMDD_HHMMSS)"
        return 0
    }
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# extract - universal archive extractor
extract() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: extract <archive>"
        echo "  Extract any archive format"
        echo ""
        echo "Supported: .tar.gz .tar.bz2 .tar.xz .zip .rar .7z .gz .bz2"
        return 0
    }
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
ports() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: ports"
        echo "  Show all listening ports"
        return 0
    }
    lsof -i -P -n | grep LISTEN
}

# myip - show public IP
myip() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: myip"
        echo "  Show public IP address"
        return 0
    }
    curl -s ifconfig.me && echo ""
}

# localip - show local IP
localip() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: localip"
        echo "  Show local IP address (en0)"
        return 0
    }
    ipconfig getifaddr en0
}

# weather - show weather (optional city)
weather() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: weather [city]"
        echo "  Show weather for current location or specified city"
        return 0
    }
    curl -s "wttr.in/${1:-}?format=3"
}

# dlx - download and extract
dlx() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: dlx <url> [options]
  Download file and automatically extract it

Options:
  -k, --keep       Keep the archive after extraction
  -o, --output     Output directory for extraction

Supported formats: .tar.gz .tar.bz2 .tar.xz .zip .rar .7z .gz .bz2

Examples:
  dlx https://example.com/file.tar.gz
  dlx https://example.com/file.zip -k           # Keep archive
  dlx https://example.com/file.tar.gz -o ./out  # Extract to ./out
EOF
        return 0
    fi

    local url="" keep=false outdir="."

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -k|--keep) keep=true; shift ;;
            -o|--output) outdir="$2"; shift 2 ;;
            -*) echo "Unknown option: $1"; return 1 ;;
            *) url="$1"; shift ;;
        esac
    done

    [[ -z "$url" ]] && { echo "Usage: dlx <url> [-k] [-o dir]"; return 1; }

    local filename=$(basename "$url")

    echo "Downloading: $filename"
    if command -v wget &>/dev/null; then
        wget -q --show-progress "$url" -O "$filename" || { echo "Download failed"; return 1; }
    elif command -v curl &>/dev/null; then
        curl -L --progress-bar "$url" -o "$filename" || { echo "Download failed"; return 1; }
    else
        echo "Neither wget nor curl found"
        return 1
    fi

    echo "Extracting: $filename"
    [[ "$outdir" != "." ]] && mkdir -p "$outdir"

    # Extract based on extension (using existing extract function logic)
    case "$filename" in
        *.tar.bz2) tar xjf "$filename" -C "$outdir" ;;
        *.tar.gz)  tar xzf "$filename" -C "$outdir" ;;
        *.tar.xz)  tar xJf "$filename" -C "$outdir" ;;
        *.bz2)     bunzip2 "$filename" ;;
        *.gz)      gunzip "$filename" ;;
        *.tar)     tar xf "$filename" -C "$outdir" ;;
        *.tbz2)    tar xjf "$filename" -C "$outdir" ;;
        *.tgz)     tar xzf "$filename" -C "$outdir" ;;
        *.zip)     unzip -q "$filename" -d "$outdir" ;;
        *.Z)       uncompress "$filename" ;;
        *.7z)      7z x "$filename" -o"$outdir" ;;
        *.rar)     unrar x "$filename" "$outdir" ;;
        *)         echo "Cannot extract '$filename' - unknown format"; return 1 ;;
    esac

    # Remove archive unless --keep
    if [[ "$keep" == false ]]; then
        rm "$filename"
        echo "Done! (archive removed)"
    else
        echo "Done! (archive kept)"
    fi
}

