##### Variables #####

# Folder where your diffs are located.
DIFFPATH="/d/diffs/"

# Default directory to load up.
DEFAULTDIR="/d/documents/code"

##### Colors #####

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

# Change the color of the prompt (messes up Git prompt)
#PS1="\e[0;31m[\u@\h \W]\$ \e[m "


##### Git Helpers #####

### Aliases ###

# Amends all staged changes to last commit.
alias git_amend_commit='git commit -a --amend --no-edit'

# Prints out a list of all the changed files from the last commit.
alias git_changed_files='git diff-tree --no-commit-id --name-only -r $(git log -1 --format="%H")'

# Prints out a count of the amount of changed files.
alias git_changed_files_count='git_changed_files | wc -l'

# Prints the short text of the current branch name.
alias git_current_branch_name='git symbolic-ref HEAD --short'

# Removes a branch. Calls git_remove_branch
alias git_delete_branch='git_remove_branch'

# Removes all .rej files.
alias git_remove_rej='find . -name "*.rej" -exec rm -f {} \;'

# Prints out the last commit.
alias git_last_commit='git log -1'

# Shows a diff between the last two commits.
alias git_last_commit_diff='git diff HEAD^ HEAD'

# Prints out the hash of the last commit.
alias git_last_commit_hash='git log -1 --format="%H"'

# Prints the list of deleted files
alias git_show_deleted_files='git log --diff-filter=D --summary | grep delete'

# Undo the last commit. The changes from the last commit will be staged for commit.
alias git_reset_last_commit='git reset --soft HEAD^'

# Unstage everything.
alias git_unstage='git reset HEAD .'

# All the memes
alias such=git
alias very=git
alias wow='git status'

### Functions ###

# Applies a diff patch
function git_apply_patch()
{
  git apply --ignore-space-change --ignore-whitespace --reject --whitespace=fix "$DIFFPATH${1}.patch"
}

# Gets rid of ALL untracked files and uncommitted changes.
function git_clean()
{
  git reset HEAD . # Unstages all changes
  git clean -f -d # Deletes untracked files and directories.
  git checkout -- . # Discard all changes to tracked changes
}

# Creates a new branch.
function git_create_branch()
{
  if git_is_on_branch "master"; then
    git checkout -b "${1}"
  else
    git checkout master
    git pull
    git checkout -b "${1}"
  fi
}


# Creates a diff patch (use for uncommitted changes)
function git_diff_patch()
{
  git diff origin/master --full-index -M > "$DIFFPATH${1}.patch"
}

# Tests if the current branch is the same branch as the argument or not.
function git_is_on_branch()
{
  # Will return the result of this test.
  # True being 0, and false being 1
  [ $(git_current_branch_name) == "${1}" ]
}


# Sends all COMMITTED changes from origin/master to the file name specified in the argument
# For example, git_patch testing would create a file called testing.patch in /d/diffs
# If necessary, make a temporary commit and then reset by doing git reset HEAD^
function git_patch()
{
  git format-patch origin/master --stdout --full-index > "$DIFFPATH${1}.patch"
}

# Renames the current branch.
function git_rename_branch()
{
  git branch -m "${1}"
}

# Removes a branch (switches to master if we are on the branch currently).
function git_remove_branch()
{
  # If we are on the branch we are trying to delete, switch to master.
  if git_is_on_branch "${1}"; then
    git checkout master
  fi

  # Delete the branch.
  git branch -D "${1}"
}

# Sets the remote upstream branch for the current branch.
function git_set_remote()
{
  git branch --set-upstream-to="origin/${1}"
}

##### Aliases #####

# Switches to php dir.
alias dphp="cd /d/php"

# Switches to resources dir.
alias dres="cd /d/resources"

##### Functions #####

# List out all custom aliases and functions.
function list_commands()
{
  # Create a temp array for storing output
  TEMPARR=()
  # Get all of the alises. First, strip out the 'alias ' text. Second, strip out the value of the aliases.
  TEMPARR+=($(alias | sed -e "s/alias //g" -e "s/=.*//g"))
  # Get all of the functions. First, remove any functions that start with _ (as they are internal git functions). Second, strip out 'declare -f '.
  TEMPARR+=($(declare -F | egrep -v "\<_" | sed "s/declare -f //g"))

  # Sort the array, and print the results with one item per line.
  # If no arguments are given, print out just the git commands.
  if [ $# -eq 0  ] ; then
    printf '%s\n' "${TEMPARR[@]}" | sort | grep git_
  # If we passed in the argument 'a'', print out all commands
  elif [ ${1} == 'all' ]; then
    printf '%s\n' "${TEMPARR[@]}" | sort
  fi
}
# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset
# Sets up ssh-agent so we don't have to authenticate every time.
function set_up_ssh_agent()
{
  eval "$(ssh-agent)" > /dev/null # We don't care about the output.
  ssh-add
}

# Reloads bashrc
function reload()
{
  export LAST_DIR=$(pwd) # Save the current working directory so we can switch back to it after reload.
  source ${HOME}/.bashrc
}


function colortest() {
(set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
}


##### Startup Commands #####

# Changes directory to php repo on startup (DOES NOT change home directory).
cd $DEFAULTDIR

# Log into ssh once to avoid doing it every time.
set_up_ssh_agent

# If this is the first time loading the shell, go to default directory.
# Otherwise, go to the directory we were working in before reload
if [[ -z "$LAST_DIR" ]]; then cd $DEFAULTDIR; else cd $LAST_DIR; fi
