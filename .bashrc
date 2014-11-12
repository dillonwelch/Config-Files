##### Variables #####

# Folder where your diffs are located.
DIFFPATH="/tmp/"

# Default directory to load up.
 DEFAULTDIR=~
#DEFAULTDIR=~/Code/Work/currica/web
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

# Removes a file from source control.'
alias git_remove_file='git rm --cached'

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

# Searches all remote branches for the search string.
function git_search
{
  git grep "${1}" $(git ls-remote . 'refs/remotes/*' | cut -f 2)
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

# Switches to the Dropbox code directory on Mac.
alias macdbc="cd ~/Dropbox/Documents/Documents/Code"

alias qcode="cd ~/Code/Work/currica/"

alias install_vundle="git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim"

alias update_vim_plugins="vim +PluginInstall +qall"

# Creates a symbolic link to a file
# symlink /path/to/original/file /path/to/symlink
alias symlink="ln -s"

# SSH's into Nick's computer.
alias nssh="ssh nick@172.16.1.6"

alias v="/Applications/MacVim.app/Contents/MacOS/Vim"

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

function setup_vim()
(
  mkdir ~/.vim/bundle
  install_vundle
  install_ycm
  install_command_t
)

function install_command_t()
(
  cd ~/.vim/bundle/command-t/ruby/command-t
  ruby extconf.rb
  make
)

function install_nokogiri()
(
  gem uninstall nokogiri
  xcode-select --install
  gem install nokogiri
)


function setup_dev_database()
(
  rake db:drop
  rake db:create
  pg_restore --verbose --clean --no-acl --no-owner -d currica_development ~/Code/Work/currica/currica-db.dump
  rake db:migrate
  #rails c
  #@user = User.find_by_email('rreas@q-centrix.com')
  #@user.password = blah
  #@user.password_confirmation = blah
  #@user.save
)

# Installs the YCM vim plugin
function install_ycm()
(
  #brew install cmake
  cd ~/.vim/bundle/YouCompleteMe/third_party/ycmd
  ./build.sh --clang-compiler
)

##### Startup Commands #####

# Changes directory on startup (DOES NOT change home directory).
cd $DEFAULTDIR

# Log into ssh once to avoid doing it every time.
#set_up_ssh_agent

# If this is the first time loading the shell, go to default directory.
# Otherwise, go to the directory we were working in before reload
if [[ -z "$LAST_DIR" ]]; then cd $DEFAULTDIR; else cd $LAST_DIR; fi

# Adds Git Auto-Complete.
source ~/git-completion.bash

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin
