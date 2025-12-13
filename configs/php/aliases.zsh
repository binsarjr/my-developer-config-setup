# =============================================================================
# PHP & Laravel Aliases
# =============================================================================

# Artisan
_reg art    "php artisan"               "Laravel Artisan CLI tool" "laravel,php"
_reg artm   "php artisan migrate"       "Run pending Laravel database migrations" "laravel,migrate,db"
_reg artmf  "php artisan migrate:fresh" "Drop all tables & re-run all migrations" "laravel,migrate,db"
_reg artmfs "php artisan migrate:fresh --seed" "Fresh migration + run database seeders" "laravel,migrate,db,seed"
_reg artmr  "php artisan migrate:rollback" "Rollback the last batch of migrations" "laravel,migrate,db"
_reg arts   "php artisan serve"         "Start Laravel development server (localhost:8000)" "laravel,serve"
_reg artt   "php artisan tinker"        "Open Laravel REPL for interactive testing" "laravel,tinker,repl"
_reg artc   "php artisan cache:clear"   "Clear Laravel application cache" "laravel,cache"
_reg artcc  "php artisan config:clear"  "Clear cached Laravel configuration" "laravel,cache,config"
_reg artrc  "php artisan route:cache"   "Cache routes for faster route resolution" "laravel,route"
_reg artrl  "php artisan route:list"    "Display all registered routes with details" "laravel,route"
_reg artdb  "php artisan db:seed"       "Run database seeders to populate tables" "laravel,db,seed"
_reg artmk  "php artisan make:"         "Generate Laravel scaffolding (model, controller, etc)" "laravel,make,scaffold"

# Composer
_reg ci     "composer install"          "Install PHP dependencies from composer.lock" "php,composer,install"
_reg cu     "composer update"           "Update PHP dependencies to latest versions" "php,composer,update"
_reg cr     "composer require"          "Add new PHP package to project" "php,composer,require"
_reg crd    "composer require --dev"    "Add PHP package as dev dependency" "php,composer,require"
_reg cdu    "composer dump-autoload"    "Regenerate Composer autoloader" "php,composer,autoload"
_reg cda    "composer dump-autoload -o" "Regenerate autoloader (optimized for prod)" "php,composer,autoload"

# Laravel Sail (Docker)
_reg sail   "./vendor/bin/sail"         "Laravel Sail - Docker dev environment CLI" "laravel,sail,docker"
_reg sa     "sail artisan"              "Run Artisan inside Sail Docker container" "laravel,sail,docker"
_reg sac    "sail artisan cache:clear"  "Clear cache inside Sail container" "laravel,sail,cache"
_reg sam    "sail artisan migrate"      "Run migrations inside Sail container" "laravel,sail,migrate"
_reg samf   "sail artisan migrate:fresh --seed" "Fresh migrate + seed in Sail" "laravel,sail,migrate,seed"

# PHPUnit / Pest
_reg pf     "./vendor/bin/phpunit --filter" "Run PHPUnit tests matching filter pattern" "php,test,phpunit"
_reg pu     "./vendor/bin/phpunit"      "Run all PHPUnit tests" "php,test,phpunit"
_reg pest   "./vendor/bin/pest"         "Run all Pest tests" "laravel,test,pest"
_reg pestf  "./vendor/bin/pest --filter" "Run Pest tests matching filter pattern" "laravel,test,pest"

# Laravel utilities
_reg lnew   "composer create-project laravel/laravel" "Create new Laravel project from scratch" "laravel,create,new"
_reg laralog "tail -f storage/logs/laravel.log" "Watch Laravel log file in real-time" "laravel,log,debug"

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

