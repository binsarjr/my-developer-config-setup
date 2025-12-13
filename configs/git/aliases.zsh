# =============================================================================
# Git Aliases
# =============================================================================

# Basic operations
_reg g      "git"                       "Git command shortcut" "git"
_reg gs     "git status"                "Show Git working tree status (modified/staged files)" "git,status"
_reg ga     "git add"                   "Stage specific files for next commit" "git,stage"
_reg gaa    "git add -A"                "Stage ALL changes including new & deleted files" "git,stage"
_reg gc     "git commit -m"             "Create Git commit with inline message" "git,commit"
_reg gca    "git commit --amend"        "Modify the last commit (message or content)" "git,commit"
_reg gp     "git push"                  "Upload local commits to remote repository" "git,remote,push"
_reg gpf    "git push --force-with-lease" "Force push safely (fails if remote changed)" "git,remote,push"
_reg gl     "git pull"                  "Fetch and merge changes from remote" "git,remote,pull"

# Branching
_reg gb     "git branch"                "List all local Git branches" "git,branch"
_reg gbd    "git branch -d"             "Delete a local branch (safe, checks merge)" "git,branch"
_reg gco    "git checkout"              "Switch branches or restore files" "git,branch,checkout"
_reg gcob   "git checkout -b"           "Create new branch and switch to it" "git,branch,checkout"
_reg gsw    "git switch"                "Switch to another branch" "git,branch,switch"
_reg gswc   "git switch -c"             "Create new branch and switch to it" "git,branch,switch"
_reg gm     "git merge"                 "Merge another branch into current branch" "git,branch,merge"

# Viewing
_reg gd     "git diff"                  "Show unstaged changes in working directory" "git,diff"
_reg gds    "git diff --staged"         "Show changes staged for next commit" "git,diff"
_reg glog   "git log --oneline --graph --decorate" "Pretty Git log with branch graph" "git,log,history"
_reg gloga  "git log --oneline --graph --decorate --all" "Git log showing ALL branches" "git,log,history"

# Stash
_reg gst    "git stash"                 "Temporarily save uncommitted changes" "git,stash"
_reg gstp   "git stash pop"             "Restore last stashed changes & remove from stash" "git,stash"
_reg gstl   "git stash list"            "List all stashed changesets" "git,stash"

# Reset & Clean
_reg grh    "git reset HEAD"            "Unstage files (keep changes in working dir)" "git,reset,undo"
_reg grhh   "git reset HEAD --hard"     "DISCARD all changes, reset to last commit" "git,reset,undo"
_reg gclean "git clean -fd"             "Remove all untracked files & directories" "git,clean,undo"

# Remote
_reg gf     "git fetch"                 "Download objects from remote (no merge)" "git,remote,fetch"
_reg gfa    "git fetch --all"           "Fetch from all configured remotes" "git,remote,fetch"
_reg gr     "git remote -v"             "List remote repositories with URLs" "git,remote"

# Quick combos
_reg gac    'git add -A && git commit -m' "Stage ALL + commit in one command" "git,workflow,commit"
_reg wip    'git add -A && git commit -m "WIP"' "Quick 'Work In Progress' commit" "git,workflow,commit"
_reg nah    'git reset --hard && git clean -df' "DISCARD everything, back to clean state" "git,workflow,undo"
