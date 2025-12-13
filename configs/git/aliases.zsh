# =============================================================================
# Git Aliases
# =============================================================================

# Basic operations
_reg g      "git"                       "Git command shortcut"
_reg gs     "git status"                "Show Git working tree status (modified/staged files)"
_reg ga     "git add"                   "Stage specific files for next commit"
_reg gaa    "git add -A"                "Stage ALL changes including new & deleted files"
_reg gc     "git commit -m"             "Create Git commit with inline message"
_reg gca    "git commit --amend"        "Modify the last commit (message or content)"
_reg gp     "git push"                  "Upload local commits to remote repository"
_reg gpf    "git push --force-with-lease" "Force push safely (fails if remote changed)"
_reg gl     "git pull"                  "Fetch and merge changes from remote"

# Branching
_reg gb     "git branch"                "List all local Git branches"
_reg gbd    "git branch -d"             "Delete a local branch (safe, checks merge)"
_reg gco    "git checkout"              "Switch branches or restore files"
_reg gcob   "git checkout -b"           "Create new branch and switch to it"
_reg gsw    "git switch"                "Switch to another branch"
_reg gswc   "git switch -c"             "Create new branch and switch to it"
_reg gm     "git merge"                 "Merge another branch into current branch"

# Viewing
_reg gd     "git diff"                  "Show unstaged changes in working directory"
_reg gds    "git diff --staged"         "Show changes staged for next commit"
_reg glog   "git log --oneline --graph --decorate" "Pretty Git log with branch graph"
_reg gloga  "git log --oneline --graph --decorate --all" "Git log showing ALL branches"

# Stash
_reg gst    "git stash"                 "Temporarily save uncommitted changes"
_reg gstp   "git stash pop"             "Restore last stashed changes & remove from stash"
_reg gstl   "git stash list"            "List all stashed changesets"

# Reset & Clean
_reg grh    "git reset HEAD"            "Unstage files (keep changes in working dir)"
_reg grhh   "git reset HEAD --hard"     "DISCARD all changes, reset to last commit"
_reg gclean "git clean -fd"             "Remove all untracked files & directories"

# Remote
_reg gf     "git fetch"                 "Download objects from remote (no merge)"
_reg gfa    "git fetch --all"           "Fetch from all configured remotes"
_reg gr     "git remote -v"             "List remote repositories with URLs"

# Quick combos
_reg gac    'git add -A && git commit -m' "Stage ALL + commit in one command"
_reg wip    'git add -A && git commit -m "WIP"' "Quick 'Work In Progress' commit"
_reg nah    'git reset --hard && git clean -df' "DISCARD everything, back to clean state"
