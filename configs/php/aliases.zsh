# =============================================================================
# PHP & Laravel Aliases
# =============================================================================

# Artisan
_reg art    "php artisan"               "Laravel Artisan CLI tool"
_reg artm   "php artisan migrate"       "Run pending Laravel database migrations"
_reg artmf  "php artisan migrate:fresh" "Drop all tables & re-run all migrations"
_reg artmfs "php artisan migrate:fresh --seed" "Fresh migration + run database seeders"
_reg artmr  "php artisan migrate:rollback" "Rollback the last batch of migrations"
_reg arts   "php artisan serve"         "Start Laravel development server (localhost:8000)"
_reg artt   "php artisan tinker"        "Open Laravel REPL for interactive testing"
_reg artc   "php artisan cache:clear"   "Clear Laravel application cache"
_reg artcc  "php artisan config:clear"  "Clear cached Laravel configuration"
_reg artrc  "php artisan route:cache"   "Cache routes for faster route resolution"
_reg artrl  "php artisan route:list"    "Display all registered routes with details"
_reg artdb  "php artisan db:seed"       "Run database seeders to populate tables"
_reg artmk  "php artisan make:"         "Generate Laravel scaffolding (model, controller, etc)"

# Composer
_reg ci     "composer install"          "Install PHP dependencies from composer.lock"
_reg cu     "composer update"           "Update PHP dependencies to latest versions"
_reg cr     "composer require"          "Add new PHP package to project"
_reg crd    "composer require --dev"    "Add PHP package as dev dependency"
_reg cdu    "composer dump-autoload"    "Regenerate Composer autoloader"
_reg cda    "composer dump-autoload -o" "Regenerate autoloader (optimized for prod)"

# Laravel Sail (Docker)
_reg sail   "./vendor/bin/sail"         "Laravel Sail - Docker dev environment CLI"
_reg sa     "sail artisan"              "Run Artisan inside Sail Docker container"
_reg sac    "sail artisan cache:clear"  "Clear cache inside Sail container"
_reg sam    "sail artisan migrate"      "Run migrations inside Sail container"
_reg samf   "sail artisan migrate:fresh --seed" "Fresh migrate + seed in Sail"

# PHPUnit / Pest
_reg pf     "./vendor/bin/phpunit --filter" "Run PHPUnit tests matching filter pattern"
_reg pu     "./vendor/bin/phpunit"      "Run all PHPUnit tests"
_reg pest   "./vendor/bin/pest"         "Run all Pest tests"
_reg pestf  "./vendor/bin/pest --filter" "Run Pest tests matching filter pattern"

# Laravel utilities
_reg lnew   "composer create-project laravel/laravel" "Create new Laravel project from scratch"
_reg laralog "tail -f storage/logs/laravel.log" "Watch Laravel log file in real-time"

# Clear all Laravel caches
artclear() {
    [[ "$1" == "-h" || "$1" == "--help" ]] && {
        echo "Usage: artclear"
        echo "  Clear all Laravel caches (cache, config, route, view)"
        return 0
    }
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    echo "All caches cleared!"
}
