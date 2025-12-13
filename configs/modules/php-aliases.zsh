# =============================================================================
# PHP & Laravel Aliases
# =============================================================================

# Artisan
alias art="php artisan"
alias artm="php artisan migrate"
alias artmf="php artisan migrate:fresh"
alias artmfs="php artisan migrate:fresh --seed"
alias artmr="php artisan migrate:rollback"
alias arts="php artisan serve"
alias artt="php artisan tinker"
alias artc="php artisan cache:clear"
alias artcc="php artisan config:clear"
alias artrc="php artisan route:cache"
alias artrl="php artisan route:list"
alias artdb="php artisan db:seed"
alias artmk="php artisan make:"

# Composer
alias ci="composer install"
alias cu="composer update"
alias cr="composer require"
alias crd="composer require --dev"
alias cdu="composer dump-autoload"
alias cda="composer dump-autoload -o"

# Laravel Sail (Docker)
alias sail="./vendor/bin/sail"
alias sa="sail artisan"
alias sac="sail artisan cache:clear"
alias sam="sail artisan migrate"
alias samf="sail artisan migrate:fresh --seed"

# PHPUnit / Pest
alias pf="./vendor/bin/phpunit --filter"
alias pu="./vendor/bin/phpunit"
alias pest="./vendor/bin/pest"
alias pestf="./vendor/bin/pest --filter"

# Laravel utilities
alias lnew="composer create-project laravel/laravel"
alias laralog="tail -f storage/logs/laravel.log"

# Clear all Laravel caches
artclear() {
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    echo "All caches cleared!"
}
