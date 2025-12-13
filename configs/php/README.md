# PHP

Aliases and tools for PHP & Laravel development.

## Files

- `aliases.zsh` - PHP & Laravel aliases
- `manager.zsh` - PHP version manager (Homebrew)

## Aliases

### Artisan
| Alias | Command | Description |
|-------|---------|-------------|
| `art` | `php artisan` | Artisan CLI |
| `artm` | `php artisan migrate` | Run migrations |
| `artmf` | `php artisan migrate:fresh` | Fresh migration |
| `artmfs` | `php artisan migrate:fresh --seed` | Fresh + seed |
| `artmr` | `php artisan migrate:rollback` | Rollback |
| `arts` | `php artisan serve` | Dev server |
| `artt` | `php artisan tinker` | Laravel REPL |
| `artc` | `php artisan cache:clear` | Clear cache |
| `artrl` | `php artisan route:list` | List routes |
| `artmk` | `php artisan make:` | Generate code |

### Composer
| Alias | Command | Description |
|-------|---------|-------------|
| `ci` | `composer install` | Install deps |
| `cu` | `composer update` | Update deps |
| `cr` | `composer require` | Add package |
| `crd` | `composer require --dev` | Add dev package |
| `cdu` | `composer dump-autoload` | Regen autoloader |

### Laravel Sail
| Alias | Command | Description |
|-------|---------|-------------|
| `sail` | `./vendor/bin/sail` | Sail CLI |
| `sa` | `sail artisan` | Sail Artisan |
| `sam` | `sail artisan migrate` | Sail migrate |

### Testing
| Alias | Command | Description |
|-------|---------|-------------|
| `pu` | `./vendor/bin/phpunit` | Run PHPUnit |
| `pf` | `./vendor/bin/phpunit --filter` | Filter tests |
| `pest` | `./vendor/bin/pest` | Run Pest |

### Functions
| Function | Description |
|----------|-------------|
| `artclear` | Clear all Laravel caches |

## PHP Version Manager

Manage PHP versions via Homebrew.

| Command | Description |
|---------|-------------|
| `php-current` | Show active PHP version |
| `php-list` | List installed versions |
| `php-available` | List available versions |
| `php-switch [ver]` | Switch PHP version (fzf picker) |
| `php-install [ver]` | Install PHP version (fzf picker) |
| `php-uninstall [ver]` | Uninstall PHP version (fzf picker) |
| `php-cleanup` | Cleanup Homebrew cache |
| `php-extensions` | List PHP extensions |
| `php-help` | Show all commands |

## Usage

```zsh
# Start Laravel dev server
arts

# Fresh migration with seed
artmfs

# Clear all caches
artclear

# Switch PHP version
php-switch 8.2

# Interactive PHP switch (fzf)
php-switch

# Install new PHP version
php-install 8.3
```

## Dependencies

- Homebrew (for php-manager)
- fzf (optional, for interactive picker)
