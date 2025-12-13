# =============================================================================
# Docker & Lima Aliases
# Lima-based Docker setup (alternative to Docker Desktop/OrbStack)
# =============================================================================

# Always set Lima Docker socket (override any OrbStack remnants)
export DOCKER_HOST="unix://$HOME/.lima/docker/sock/docker.sock"

# =============================================================================
# Lima VM Management
# =============================================================================

# docker-start - Start Lima Docker VM
docker-start() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-start"
        echo "  Start the Lima Docker VM"
        return 0
    }
    echo "Starting Docker (Lima VM)..."
    limactl start docker
    echo "Docker is ready!"
}

# docker-stop - Stop Lima Docker VM
docker-stop() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-stop"
        echo "  Stop the Lima Docker VM"
        return 0
    }
    echo "Stopping Docker (Lima VM)..."
    limactl stop docker
    echo "Docker stopped."
}

# docker-restart - Restart Lima Docker VM
docker-restart() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-restart"
        echo "  Restart the Lima Docker VM"
        return 0
    }
    echo "Restarting Docker (Lima VM)..."
    limactl stop docker 2>/dev/null
    limactl start docker
    echo "Docker restarted!"
}

# docker-status - Show Lima VM status
docker-status() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-status"
        echo "  Show Lima VM status"
        return 0
    }
    limactl list
}

# docker-install - Auto install Lima + Docker
docker-install() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-install"
        echo "  Automatically install Lima + Docker CLI + Docker Compose"
        echo ""
        echo "This will:"
        echo "  1. Check/install lima, docker, docker-compose via Homebrew"
        echo "  2. Configure docker-compose plugin path"
        echo "  3. Create Lima docker VM if not exists"
        echo "  4. Start the VM"
        return 0
    }

    # Check Homebrew
    if ! command -v brew &>/dev/null; then
        echo "Homebrew required. Install: https://brew.sh"
        return 1
    fi

    # Install packages if missing
    local packages=("lima" "docker" "docker-compose")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! brew list "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        else
            echo "[ok] $pkg already installed"
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        echo "Installing: ${to_install[*]}"
        brew install "${to_install[@]}"
    fi

    # Configure docker-compose plugin path
    local docker_config="$HOME/.docker/config.json"
    local plugin_dir="/opt/homebrew/lib/docker/cli-plugins"

    if [[ ! -f "$docker_config" ]]; then
        mkdir -p "$HOME/.docker"
        echo '{"cliPluginsExtraDirs": ["'"$plugin_dir"'"]}' > "$docker_config"
        echo "[ok] Created docker config with plugin path"
    elif ! grep -q "cliPluginsExtraDirs" "$docker_config"; then
        # Add cliPluginsExtraDirs to existing config
        if command -v jq &>/dev/null; then
            local tmp=$(mktemp)
            jq '. + {"cliPluginsExtraDirs": ["'"$plugin_dir"'"]}' "$docker_config" > "$tmp" && mv "$tmp" "$docker_config"
        else
            echo "Add to $docker_config:"
            echo '  "cliPluginsExtraDirs": ["'"$plugin_dir"'"]'
        fi
        echo "[ok] Configured docker-compose plugin path"
    else
        echo "[ok] Docker plugin path already configured"
    fi

    # Create Lima VM if not exists
    if ! limactl list -q 2>/dev/null | grep -q "^docker$"; then
        echo "Creating Lima docker VM..."
        limactl create --name=docker --tty=false template:docker
    else
        echo "[ok] Lima docker VM exists"
    fi

    # Start VM
    local status=$(limactl list --format '{{.Status}}' docker 2>/dev/null)
    if [[ "$status" != "Running" ]]; then
        echo "Starting Docker VM..."
        limactl start docker
    else
        echo "[ok] Docker VM already running"
    fi

    echo ""
    echo "Docker ready! Test with: docker ps"
}

# docker-uninstall - Remove Lima + Docker
docker-uninstall() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-uninstall [-y]"
        echo "  Remove Lima Docker VM and optionally uninstall packages"
        echo ""
        echo "Options:"
        echo "  -y    Skip confirmation prompts"
        echo ""
        echo "This will:"
        echo "  1. Stop and delete Lima docker VM"
        echo "  2. Optionally uninstall lima, docker, docker-compose"
        return 0
    }

    local skip_confirm=false
    [[ "$1" == "-y" ]] && skip_confirm=true

    # Stop and delete Lima VM
    if limactl list -q 2>/dev/null | grep -q "^docker$"; then
        echo "Stopping Docker VM..."
        limactl stop docker 2>/dev/null
        echo "Deleting Docker VM..."
        limactl delete docker -f
        echo "[ok] Lima docker VM removed"
    else
        echo "[ok] No Lima docker VM found"
    fi

    # Ask to uninstall packages
    if [[ "$skip_confirm" == false ]]; then
        echo ""
        read "reply?Uninstall lima, docker, docker-compose? [y/N] "
        [[ "$reply" != [yY] ]] && { echo "Packages kept."; return 0; }
    fi

    echo "Uninstalling packages..."
    brew uninstall docker-compose docker lima 2>/dev/null
    echo ""
    echo "Docker uninstalled!"
}

# =============================================================================
# Docker Shortcuts
# =============================================================================

_reg d      "docker"                      "Docker CLI shortcut" "docker"
_reg dc     "docker compose"              "Docker Compose shortcut" "docker,compose"
_reg dps    "docker ps"                   "List running containers" "docker"
_reg dpsa   "docker ps -a"                "List all containers" "docker"
_reg di     "docker images"               "List Docker images" "docker,images"
_reg drm    "docker rm"                   "Remove container" "docker"
_reg drmi   "docker rmi"                  "Remove image" "docker,images"
_reg dlog   "docker logs -f"              "Follow container logs" "docker,logs"

# dsh - Shell into container
dsh() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: dsh <container> [shell]"
        echo "  Open shell in running container"
        echo ""
        echo "Arguments:"
        echo "  container    Container name or ID"
        echo "  shell        Shell to use (default: sh)"
        echo ""
        echo "Examples:"
        echo "  dsh nginx"
        echo "  dsh myapp bash"
        echo "  dsh postgres psql -U postgres"
        return 0
    }
    local container="$1"
    local shell="${2:-sh}"
    [[ -z "$container" ]] && { echo "Usage: dsh <container> [shell]"; return 1; }
    shift
    [[ $# -gt 0 ]] && shift
    docker exec -it "$container" "$shell" "$@"
}

# docker-prune - Clean up Docker resources
docker-prune() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: docker-prune [-a]"
        echo "  Clean up unused Docker resources"
        echo ""
        echo "Options:"
        echo "  -a, --all    Remove ALL unused images (not just dangling)"
        echo ""
        echo "This will remove:"
        echo "  - Stopped containers"
        echo "  - Unused networks"
        echo "  - Dangling images (or all unused with -a)"
        echo "  - Build cache"
        return 0
    }

    local all=""
    [[ "$1" == "-a" || "$1" == "--all" ]] && all="--all"

    echo "Cleaning up Docker resources..."
    docker container prune -f
    docker network prune -f
    docker image prune $all -f
    docker builder prune -f
    echo "Cleanup complete!"
    docker system df
}

# =============================================================================
# Lima Setup Helper
# =============================================================================

lima-setup() {
    cat << 'EOF'
Lima + Docker Setup Guide
=========================

Quick Install:
  docker-install    Auto install everything

Manual Steps:
  1. brew install lima docker docker-compose
  2. limactl create --name=docker template:docker
  3. limactl start docker
  4. docker ps

Commands:
  docker-install    Auto install Lima + Docker
  docker-uninstall  Remove Lima + Docker
  docker-start      Start Docker VM
  docker-stop       Stop Docker VM
  docker-restart    Restart Docker VM
  docker-status     Show VM status
  docker-prune      Clean up unused resources

Shortcuts:
  d, dc           docker, docker compose
  dps, dpsa       docker ps, docker ps -a
  di              docker images
  dsh <container> Shell into container
  ld              lazydocker (TUI)

EOF
}

# Register Docker/Lima commands
_reg docker-start    "docker-start"    "Start Lima Docker VM" "docker,lima"
_reg docker-stop     "docker-stop"     "Stop Lima Docker VM" "docker,lima"
_reg docker-restart  "docker-restart"  "Restart Lima Docker VM" "docker,lima"
_reg docker-status   "docker-status"   "Show Lima VM status" "docker,lima"
_reg docker-install  "docker-install"  "Install Lima + Docker" "docker,lima,install"
_reg docker-uninstall "docker-uninstall" "Remove Lima + Docker" "docker,lima,uninstall"
_reg docker-prune    "docker-prune"    "Clean unused Docker resources" "docker,cleanup"
_reg dsh             "dsh"             "Shell into container" "docker,shell"
_reg lima-setup      "lima-setup"      "Show Lima setup guide" "docker,lima,help"
