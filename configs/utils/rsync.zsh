# =============================================================================
# Rsync Utilities
# Smart copy, backup, deploy, and sync functions
# =============================================================================

# Common excludes for dev projects
_RSYNC_DEV_EXCLUDES=(
    --exclude='node_modules/'
    --exclude='vendor/'
    --exclude='.git/'
    --exclude='__pycache__/'
    --exclude='*.pyc'
    --exclude='.DS_Store'
    --exclude='.env.local'
    --exclude='.env.*.local'
    --exclude='*.log'
    --exclude='.cache/'
    --exclude='.tmp/'
    --exclude='tmp/'
    --exclude='dist/'
    --exclude='build/'
)

# Laravel-specific excludes
_RSYNC_LARAVEL_EXCLUDES=(
    "${_RSYNC_DEV_EXCLUDES[@]}"
    --exclude='storage/logs/'
    --exclude='storage/framework/cache/'
    --exclude='storage/framework/sessions/'
    --exclude='storage/framework/views/'
    --exclude='bootstrap/cache/'
    --exclude='storage/app/public/'
)

# Node.js-specific excludes
_RSYNC_NODE_EXCLUDES=(
    "${_RSYNC_DEV_EXCLUDES[@]}"
    --exclude='.next/'
    --exclude='.nuxt/'
    --exclude='.output/'
    --exclude='coverage/'
    --exclude='.turbo/'
)

# =============================================================================
# Helper: Rsync confirmation with trailing slash explanation
# =============================================================================

_rsync_show_confirmation() {
    local action="$1"
    shift
    local args=("$@")
    local dest="${args[-1]}"
    local sources=("${args[@]:0:${#args[@]}-1}")

    echo ""
    echo -e "\033[1m$action Preview:\033[0m"
    echo ""

    # Show each source with trailing slash explanation
    for src in "${sources[@]}"; do
        local src_display="${src/#$HOME/~}"
        if [[ "$src" == */ ]]; then
            echo -e "  Source:      \033[36m$src_display\033[0m (contents of folder)"
        elif [[ -d "$src" ]]; then
            echo -e "  Source:      \033[36m$src_display\033[0m (folder itself)"
        else
            echo -e "  Source:      \033[36m$src_display\033[0m"
        fi
    done

    local dest_display="${dest/#$HOME/~}"
    echo -e "  Destination: \033[36m$dest_display\033[0m"
    echo ""

    # Show trailing slash tip for directories
    if [[ ${#sources[@]} -eq 1 && -d "${sources[0]}" ]]; then
        local src="${sources[0]}"
        local src_name=$(basename "$src")
        if [[ "$src" == */ ]]; then
            echo -e "  \033[2mResult: Files will be placed directly in $dest_display\033[0m"
        else
            echo -e "  \033[2mResult: Creates $dest_display/$src_name/\033[0m"
            echo -e "  \033[2mTip: Add trailing slash ($src/) to copy contents only\033[0m"
        fi
        echo ""
    fi
}

_rsync_confirm() {
    echo -n "Proceed? [Y/n]: "
    read -r response
    [[ -z "$response" || "$response" =~ ^[Yy]$ ]]
}

# =============================================================================
# Smart Copy/Move (with progress)
# =============================================================================

# cpr - Copy with progress bar and resume capability
cpr() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: cpr [options] <source>... <destination>
  Copy files/directories with progress bar and resume capability
  Supports multiple sources like native cp command

Rsync command:
  rsync -ah --progress --partial <sources>... <destination>

Flags explained:
  -a, --archive    Archive mode: preserves permissions, timestamps,
                   symlinks, owner, group, and copies recursively
  -h, --human      Show file sizes in human-readable format (KB, MB, GB)
  --progress       Display transfer progress for each file
  --partial        Keep partially transferred files, enabling resume
                   if transfer is interrupted (Ctrl+C)

Options:
  -n, --dry-run    Preview what would be copied without actually copying
  -y, --yes        Skip confirmation prompt

Trailing slash behavior (IMPORTANT):
  source/  → Copy CONTENTS of folder into destination
  source   → Copy FOLDER itself into destination

  Example:
    cpr Photos/ /Backup/     → /Backup/img1.jpg, /Backup/img2.jpg
    cpr Photos /Backup/      → /Backup/Photos/img1.jpg, /Backup/Photos/img2.jpg

Examples:
  cpr movie.mp4 /Volumes/USB/
  cpr file1.txt file2.txt file3.txt /Volumes/USB/   # Multiple sources
  cpr *.mp4 /Volumes/External/Videos/               # Wildcard
  cpr -y ~/Projects /Volumes/Backup/                # Skip confirmation
EOF
        return 0
    fi

    local dry_run="" skip_confirm=false
    while [[ "$1" == -* ]]; do
        case "$1" in
            -n|--dry-run) dry_run="--dry-run"; shift ;;
            -y|--yes) skip_confirm=true; shift ;;
            *) shift ;;
        esac
    done

    [[ $# -lt 2 ]] && { echo "Usage: cpr <source>... <destination>"; return 1; }

    # Show confirmation unless skipped or dry-run
    if [[ "$skip_confirm" == false && -z "$dry_run" ]]; then
        _rsync_show_confirmation "Copy" "$@"
        _rsync_confirm || { echo "Cancelled."; return 0; }
        echo ""
    fi

    rsync -ah --progress --partial $dry_run "$@"
}

# mvr - Move with progress bar
mvr() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: mvr [options] <source>... <destination>
  Move files/directories with progress bar (copy then delete source)
  Supports multiple sources like native mv command

Rsync command:
  rsync -ah --progress --remove-source-files <sources>... <destination>

Flags explained:
  -a, --archive             Archive mode: preserves all file attributes
  -h, --human               Human-readable file sizes
  --progress                Show transfer progress
  --remove-source-files     Delete source files after successful transfer
                            (directories are NOT deleted, only files inside)

Options:
  -y, --yes        Skip confirmation prompt

Trailing slash behavior (IMPORTANT):
  source/  → Move CONTENTS of folder into destination
  source   → Move FOLDER itself into destination

  Example:
    mvr Photos/ /Backup/     → /Backup/img1.jpg (Photos/ becomes empty)
    mvr Photos /Backup/      → /Backup/Photos/img1.jpg

Examples:
  mvr large-file.zip /Volumes/External/
  mvr file1.txt file2.txt file3.txt ~/Documents/   # Multiple sources
  mvr ~/Downloads/*.iso /Volumes/USB/              # Wildcard
  mvr -y ~/old-files /Volumes/Archive/             # Skip confirmation

Note: Empty source directories are automatically removed after move.
EOF
        return 0
    fi

    local skip_confirm=false
    while [[ "$1" == -* ]]; do
        case "$1" in
            -y|--yes) skip_confirm=true; shift ;;
            *) shift ;;
        esac
    done

    [[ $# -lt 2 ]] && { echo "Usage: mvr <source>... <destination>"; return 1; }

    # Save sources for cleanup (all args except last)
    local args=("$@")
    local sources=("${args[@]:0:${#args[@]}-1}")

    # Show confirmation unless skipped
    if [[ "$skip_confirm" == false ]]; then
        _rsync_show_confirmation "Move" "$@"
        echo -e "  \033[33mWarning: Source files will be DELETED after transfer\033[0m"
        echo ""
        _rsync_confirm || { echo "Cancelled."; return 0; }
        echo ""
    fi

    rsync -ah --progress --remove-source-files "$@"

    # Remove empty directories left behind by rsync
    for src in "${sources[@]}"; do
        if [[ -d "$src" ]]; then
            find "$src" -type d -empty -delete 2>/dev/null
            # Remove the source dir itself if now empty
            [[ -d "$src" ]] && rmdir "$src" 2>/dev/null
        fi
    done
}

# =============================================================================
# Backup Functions
# =============================================================================

# backup-dev - Backup developer directory
backup-dev() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: backup-dev <destination>
  Backup ~/Developers directory to external drive or remote location

Rsync command:
  rsync -avh --progress --partial --exclude='...' ~/Developers/ <dest>/

Flags explained:
  -a, --archive    Preserve permissions, timestamps, symlinks, recursively
  -v, --verbose    Show files being transferred
  -h, --human      Human-readable file sizes
  --progress       Show progress for each file
  --partial        Keep partial files for resume capability
  --exclude='...'  Skip unnecessary files (see list below)

Excluded directories (to save space & time):
  node_modules/    - npm packages (reinstall with: npm install)
  vendor/          - composer packages (reinstall with: composer install)
  .git/            - git history (can be large, clone from remote instead)
  __pycache__/     - Python cache
  .DS_Store        - macOS metadata
  *.log            - Log files
  dist/, build/    - Build outputs (can be regenerated)

Options:
  -n, --dry-run    Preview what would be backed up

Examples:
  backup-dev /Volumes/External/Backup/Developers
  backup-dev user@nas:/backup/Developers    # To remote NAS via SSH
  backup-dev -n /Volumes/USB/               # Preview only
EOF
        return 0
    fi

    local dry_run=""
    [[ "$1" == "-n" || "$1" == "--dry-run" ]] && { dry_run="--dry-run"; shift; }

    [[ -z "$1" ]] && { echo "Usage: backup-dev <destination>"; return 1; }

    echo "Backing up ~/Developers to $1..."
    rsync -avh --progress --partial $dry_run \
        "${_RSYNC_DEV_EXCLUDES[@]}" \
        ~/Developers/ "$1/"

    echo "Backup complete!"
}

# backup-sync - General backup with smart excludes
backup-sync() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: backup-sync <source> <destination>
  Backup any directory with smart excludes for dev projects

Rsync command:
  rsync -avh --progress --partial --exclude='...' <source>/ <dest>/

Flags explained:
  -a, --archive    Preserve all attributes, copy recursively
  -v, --verbose    List files being transferred
  -h, --human      Human-readable sizes
  --progress       Show progress per file
  --partial        Enable resume for interrupted transfers

Options:
  -n, --dry-run    Preview changes without copying
  --delete         Mirror mode: delete files in dest that don't exist in source
                   WARNING: This will remove extra files in destination!

Examples:
  backup-sync ~/Projects /Volumes/Backup/Projects
  backup-sync -n ~/Documents /Volumes/External/Docs   # Preview
  backup-sync --delete ~/Code /Volumes/Mirror/Code    # Exact mirror
EOF
        return 0
    fi

    local dry_run="" delete=""
    while [[ "$1" == -* ]]; do
        case "$1" in
            -n|--dry-run) dry_run="--dry-run"; shift ;;
            --delete) delete="--delete"; shift ;;
            *) shift ;;
        esac
    done

    [[ -z "$1" || -z "$2" ]] && { echo "Usage: backup-sync <source> <destination>"; return 1; }

    rsync -avh --progress --partial $dry_run $delete \
        "${_RSYNC_DEV_EXCLUDES[@]}" \
        "$1/" "$2/"
}

# =============================================================================
# Deploy Functions
# =============================================================================

# deploy - Deploy project to remote server
deploy() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: deploy <local-path> <user@host:remote-path>
  Deploy project files to a remote server via SSH

Rsync command:
  rsync -avz --progress --exclude='...' <local>/ <remote>/

Flags explained:
  -a, --archive    Preserve permissions and structure
  -v, --verbose    Show files being transferred
  -z, --compress   Compress data during transfer (faster over network)
  --progress       Show transfer progress
  --exclude='...'  Skip dev files (node_modules, vendor, .git, etc.)

Options:
  -n, --dry-run    Preview what would be deployed
  --delete         Remove remote files not in local (mirror deploy)
                   WARNING: Use carefully! May delete server files

Examples:
  deploy ./dist user@server:/var/www/myapp
  deploy -n . user@vps:/home/user/app      # Preview
  deploy --delete ./build root@server:/var/www/html

Requirements:
  - SSH access to remote server
  - SSH key configured (or will prompt for password)
EOF
        return 0
    fi

    local dry_run="" delete=""
    while [[ "$1" == -* ]]; do
        case "$1" in
            -n|--dry-run) dry_run="--dry-run"; shift ;;
            --delete) delete="--delete"; shift ;;
            *) shift ;;
        esac
    done

    [[ -z "$1" || -z "$2" ]] && { echo "Usage: deploy <local-path> <user@host:remote-path>"; return 1; }

    echo "Deploying $1 to $2..."
    rsync -avz --progress $dry_run $delete \
        "${_RSYNC_DEV_EXCLUDES[@]}" \
        "$1/" "$2/"

    echo "Deploy complete!"
}

# deploy-laravel - Deploy Laravel project with smart excludes
deploy-laravel() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: deploy-laravel [local-path] <user@host:remote-path>
  Deploy Laravel project with optimized excludes

Rsync command:
  rsync -avz --progress --exclude='...' <local>/ <remote>/

Laravel-specific excludes:
  vendor/                      - Composer packages (run composer install on server)
  node_modules/                - NPM packages
  storage/logs/                - Log files
  storage/framework/cache/     - Cached data
  storage/framework/sessions/  - Session files
  storage/framework/views/     - Compiled views
  bootstrap/cache/             - Bootstrap cache
  .git/                        - Git history

Options:
  -n, --dry-run    Preview deployment

Examples:
  deploy-laravel user@server:/var/www/laravel
  deploy-laravel ./my-app user@server:/var/www/app
  deploy-laravel -n user@vps:/var/www/site    # Preview

After deploying, run on server:
  cd /var/www/laravel
  composer install --no-dev --optimize-autoloader
  php artisan migrate --force
  php artisan config:cache
  php artisan route:cache
  php artisan view:cache
EOF
        return 0
    fi

    local dry_run=""
    [[ "$1" == "-n" || "$1" == "--dry-run" ]] && { dry_run="--dry-run"; shift; }

    local src="."
    local dest="$1"

    [[ -n "$2" ]] && { src="$1"; dest="$2"; }

    [[ -z "$dest" ]] && { echo "Usage: deploy-laravel [local-path] <user@host:remote-path>"; return 1; }

    echo "Deploying Laravel project to $dest..."
    rsync -avz --progress $dry_run \
        "${_RSYNC_LARAVEL_EXCLUDES[@]}" \
        "$src/" "$dest/"

    echo ""
    echo "Deploy complete!"
    echo ""
    echo "Run on server:"
    echo "  composer install --no-dev --optimize-autoloader"
    echo "  php artisan migrate --force"
    echo "  php artisan config:cache"
}

# deploy-node - Deploy Node.js project with smart excludes
deploy-node() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: deploy-node [local-path] <user@host:remote-path>
  Deploy Node.js project with optimized excludes

Rsync command:
  rsync -avz --progress --exclude='...' <local>/ <remote>/

Node.js-specific excludes:
  node_modules/    - NPM packages (run npm install on server)
  .next/           - Next.js build cache
  .nuxt/           - Nuxt.js build cache
  .output/         - Nitro output
  coverage/        - Test coverage reports
  .turbo/          - Turborepo cache
  dist/, build/    - Build outputs (rebuild on server if needed)

Options:
  -n, --dry-run    Preview deployment

Examples:
  deploy-node user@server:/var/www/app
  deploy-node ./frontend user@vps:/home/app
  deploy-node -n user@server:/var/www/site    # Preview

After deploying, run on server:
  cd /var/www/app
  npm install --production
  npm run build      # If needed
  pm2 restart all    # Or your process manager
EOF
        return 0
    fi

    local dry_run=""
    [[ "$1" == "-n" || "$1" == "--dry-run" ]] && { dry_run="--dry-run"; shift; }

    local src="."
    local dest="$1"

    [[ -n "$2" ]] && { src="$1"; dest="$2"; }

    [[ -z "$dest" ]] && { echo "Usage: deploy-node [local-path] <user@host:remote-path>"; return 1; }

    echo "Deploying Node.js project to $dest..."
    rsync -avz --progress $dry_run \
        "${_RSYNC_NODE_EXCLUDES[@]}" \
        "$src/" "$dest/"

    echo ""
    echo "Deploy complete!"
    echo ""
    echo "Run on server:"
    echo "  npm install --production"
    echo "  npm run build  # if needed"
}

# =============================================================================
# Sync Between Machines
# =============================================================================

# sync-push - Push local directory to remote machine
sync-push() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: sync-push <host> [directory]
  Push local directory to another machine via SSH

Rsync command:
  rsync -avz --progress --partial --exclude='...' <local>/ <host>:<remote>/

Flags explained:
  -a, --archive    Preserve permissions, timestamps, symlinks
  -v, --verbose    Show files being synced
  -z, --compress   Compress during transfer (faster over network)
  --progress       Show progress per file
  --partial        Enable resume if interrupted
  --exclude='...'  Skip node_modules, vendor, .git, etc.

Arguments:
  <host>           SSH host (e.g., desktop, user@192.168.1.10)
  [directory]      Local directory to sync (default: ~/Developers)

Options:
  -n, --dry-run    Preview what would be synced

Examples:
  sync-push desktop                    # Push ~/Developers to desktop
  sync-push user@192.168.1.100         # Push to IP address
  sync-push macbook-pro ~/Projects     # Push specific directory
  sync-push -n laptop                  # Preview only

Setup SSH config (~/.ssh/config) for easier usage:
  Host desktop
      HostName 192.168.1.10
      User john
EOF
        return 0
    fi

    local dry_run=""
    [[ "$1" == "-n" || "$1" == "--dry-run" ]] && { dry_run="--dry-run"; shift; }

    local host="$1"
    local dir="${2:-$HOME/Developers}"

    [[ -z "$host" ]] && { echo "Usage: sync-push <host> [directory]"; return 1; }

    local remote_dir="${dir/#$HOME/~}"

    echo "Pushing $dir to $host:$remote_dir..."
    rsync -avz --progress --partial $dry_run \
        "${_RSYNC_DEV_EXCLUDES[@]}" \
        "$dir/" "$host:$remote_dir/"

    echo "Sync complete!"
}

# sync-pull - Pull directory from remote machine
sync-pull() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat << 'EOF'
Usage: sync-pull <host> [directory]
  Pull directory from another machine to local via SSH

Rsync command:
  rsync -avz --progress --partial --exclude='...' <host>:<remote>/ <local>/

Arguments:
  <host>           SSH host (e.g., desktop, user@192.168.1.10)
  [directory]      Local directory to sync to (default: ~/Developers)

Options:
  -n, --dry-run    Preview what would be synced

Examples:
  sync-pull desktop                    # Pull ~/Developers from desktop
  sync-pull user@192.168.1.100         # Pull from IP address
  sync-pull macbook-pro ~/Projects     # Pull to specific directory
  sync-pull -n laptop                  # Preview only

Typical workflow (2 machines):
  On machine A: sync-push machine-b    # Send changes to B
  On machine B: sync-pull machine-a    # Get changes from A
EOF
        return 0
    fi

    local dry_run=""
    [[ "$1" == "-n" || "$1" == "--dry-run" ]] && { dry_run="--dry-run"; shift; }

    local host="$1"
    local dir="${2:-$HOME/Developers}"

    [[ -z "$host" ]] && { echo "Usage: sync-pull <host> [directory]"; return 1; }

    local remote_dir="${dir/#$HOME/~}"

    echo "Pulling $host:$remote_dir to $dir..."
    rsync -avz --progress --partial $dry_run \
        "${_RSYNC_DEV_EXCLUDES[@]}" \
        "$host:$remote_dir/" "$dir/"

    echo "Sync complete!"
}

# =============================================================================
# Help
# =============================================================================

rsync-help() {
    cat << 'EOF'

Rsync Utilities
===============

Smart Copy:
  cpr <src> <dest>              Copy with progress bar (resumable)
  mvr <src> <dest>              Move with progress bar

Backup:
  backup-dev <dest>             Backup ~/Developers (excludes node_modules, etc.)
  backup-sync <src> <dest>      Backup any directory with smart excludes

Deploy (to remote server):
  deploy <local> <remote>       Deploy project to server
  deploy-laravel <remote>       Deploy Laravel (excludes vendor, storage/logs)
  deploy-node <remote>          Deploy Node.js (excludes node_modules, .next)

Sync (between machines):
  sync-push <host> [dir]        Push directory to another machine
  sync-pull <host> [dir]        Pull directory from another machine

All commands support:
  -h, --help       Show detailed help with rsync flags explanation
  -n, --dry-run    Preview changes without executing

Common rsync flags used:
  -a  Archive mode (preserve permissions, timestamps, symlinks, recursive)
  -v  Verbose (show files being transferred)
  -h  Human-readable sizes (KB, MB, GB instead of bytes)
  -z  Compress during transfer (faster over network)
  --progress       Show progress per file
  --partial        Keep partial files for resume capability
  --exclude='...'  Skip specified files/directories

EOF
}

# Register rsync commands
_reg cpr           "cpr"           "Copy with progress (rsync)" "rsync,copy"
_reg mvr           "mvr"           "Move with progress (rsync)" "rsync,move"
_reg backup-dev    "backup-dev"    "Backup dev folder" "rsync,backup"
_reg backup-sync   "backup-sync"   "Sync backup incrementally" "rsync,backup"
_reg deploy        "deploy"        "Deploy project via rsync" "rsync,deploy"
_reg deploy-laravel "deploy-laravel" "Deploy Laravel project" "rsync,deploy,laravel"
_reg deploy-node   "deploy-node"   "Deploy Node.js project" "rsync,deploy,node"
_reg sync-push     "sync-push"     "Push files to remote" "rsync,sync"
_reg sync-pull     "sync-pull"     "Pull files from remote" "rsync,sync"
_reg rsync-help    "rsync-help"    "Show rsync commands help" "rsync,help"
