# =============================================================================
# Bun Aliases
# Fast JavaScript/TypeScript runtime, package manager, and test runner
# =============================================================================

# Only load if bun is installed
command -v bun &>/dev/null || return 0

# Package Manager
_reg bi  "bun install"    "Install dependencies from bun.lockb" "bun,js,node,install"
_reg ba  "bun add"        "Add package to dependencies" "bun,js,node,add"
_reg bad "bun add -d"     "Add package to devDependencies" "bun,js,node,add"
_reg brm "bun remove"     "Remove package from project" "bun,js,node,remove"
_reg bu  "bun update"     "Update all packages to latest versions" "bun,js,node,update"
_reg bx  "bunx"           "Execute package from npm registry (like npx)" "bun,js,node,exec"

# Runtime
_reg br  "bun run"        "Run script from package.json or execute file" "bun,js,node,run"
_reg bb  "bun run build"  "Run build script (production build)" "bun,js,node,build"
_reg bs  "bun run start"  "Run start script (production server)" "bun,js,node,start"

# Testing
_reg bt  "bun test"            "Run all tests" "bun,js,node,test"
_reg btw "bun test --watch"    "Run tests in watch mode (re-run on change)" "bun,js,node,test"
_reg btc "bun test --coverage" "Run tests with code coverage report" "bun,js,node,test,coverage"
