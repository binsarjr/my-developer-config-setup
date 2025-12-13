# =============================================================================
# Bun Aliases
# Fast JavaScript/TypeScript runtime, package manager, and test runner
# =============================================================================

# Only load if bun is installed
command -v bun &>/dev/null || return 0

# Package Manager
_reg bi  "bun install"    "Install dependencies from bun.lockb"
_reg ba  "bun add"        "Add package to dependencies"
_reg bad "bun add -d"     "Add package to devDependencies"
_reg brm "bun remove"     "Remove package from project"
_reg bu  "bun update"     "Update all packages to latest versions"
_reg bx  "bunx"           "Execute package from npm registry (like npx)"

# Runtime
_reg br  "bun run"        "Run script from package.json or execute file"
_reg bd  "bun run dev"    "Run dev script (development server)"
_reg bb  "bun run build"  "Run build script (production build)"
_reg bs  "bun run start"  "Run start script (production server)"

# Testing
_reg bt  "bun test"            "Run all tests"
_reg btw "bun test --watch"    "Run tests in watch mode (re-run on change)"
_reg btc "bun test --coverage" "Run tests with code coverage report"
