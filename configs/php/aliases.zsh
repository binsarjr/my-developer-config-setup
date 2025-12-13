# =============================================================================
# PHP & Laravel Aliases
# =============================================================================

# Artisan
_reg art    "php artisan"               "Laravel Artisan CLI tool" "php,laravel,artisan"
_reg artm   "php artisan migrate"       "Run pending Laravel database migrations" "php,laravel,artisan,migrate,db"
_reg artmf  "php artisan migrate:fresh" "Drop all tables & re-run all migrations" "php,laravel,artisan,migrate,db"
_reg artmfs "php artisan migrate:fresh --seed" "Fresh migration + run database seeders" "php,laravel,artisan,migrate,db"
_reg artmr  "php artisan migrate:rollback" "Rollback the last batch of migrations" "php,laravel,artisan,migrate,db"
_reg arts   "php artisan serve"         "Start Laravel development server (localhost:8000)" "php,laravel,artisan,serve"
_reg artt   "php artisan tinker"        "Open Laravel REPL for interactive testing" "php,laravel,artisan,tinker"
_reg artc   "php artisan cache:clear"   "Clear Laravel application cache" "php,laravel,artisan,cache"
_reg artcc  "php artisan config:clear"  "Clear cached Laravel configuration" "php,laravel,artisan,cache"
_reg artrc  "php artisan route:cache"   "Cache routes for faster route resolution" "php,laravel,artisan,route"
_reg artrl  "php artisan route:list"    "Display all registered routes with details" "php,laravel,artisan,route"
_reg artdb  "php artisan db:seed"       "Run database seeders to populate tables" "php,laravel,artisan,db,seed"
_reg artmk  "php artisan make:"         "Generate Laravel scaffolding (model, controller, etc)" "php,laravel,artisan,make"

# Composer
_reg ci     "composer install"          "Install PHP dependencies from composer.lock" "php,composer,install"
_reg cu     "composer update"           "Update PHP dependencies to latest versions" "php,composer,update"
_reg cr     "composer require"          "Add new PHP package to project" "php,composer,require"
_reg crd    "composer require --dev"    "Add PHP package as dev dependency" "php,composer,require"
_reg cdu    "composer dump-autoload"    "Regenerate Composer autoloader" "php,composer,autoload"
_reg cda    "composer dump-autoload -o" "Regenerate autoloader (optimized for prod)" "php,composer,autoload"

# Laravel Sail (Docker)
_reg sail   "./vendor/bin/sail"         "Laravel Sail - Docker dev environment CLI" "php,laravel,sail,docker"
_reg sa     "sail artisan"              "Run Artisan inside Sail Docker container" "php,laravel,sail,docker,artisan"
_reg sac    "sail artisan cache:clear"  "Clear cache inside Sail container" "php,laravel,sail,docker,cache"
_reg sam    "sail artisan migrate"      "Run migrations inside Sail container" "php,laravel,sail,docker,migrate"
_reg samf   "sail artisan migrate:fresh --seed" "Fresh migrate + seed in Sail" "php,laravel,sail,docker,migrate"

# PHPUnit / Pest
_reg pf     "./vendor/bin/phpunit --filter" "Run PHPUnit tests matching filter pattern" "php,test,phpunit"
_reg pu     "./vendor/bin/phpunit"      "Run all PHPUnit tests" "php,test,phpunit"
_reg pest   "./vendor/bin/pest"         "Run all Pest tests" "php,laravel,test,pest"
_reg pestf  "./vendor/bin/pest --filter" "Run Pest tests matching filter pattern" "php,laravel,test,pest"

# Laravel utilities
_reg lnew   "composer create-project laravel/laravel" "Create new Laravel project from scratch" "php,laravel,create"
_reg laralog "tail -f storage/logs/laravel.log" "Watch Laravel log file in real-time" "php,laravel,log,debug"

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
