##### Variables #####

# Folder where your diffs are located.
DIFFPATH="/tmp/"

# Default directory to load up.
DEFAULTDIR=~/Code/

##### Aliases #####
alias rails_c_staging="heroku run rails c --app tempest-api"
alias rails_c_prod="heroku run rails c --app tempest-api-production"

alias install_vundle="git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim"

alias update_vim_plugins="vim +PluginInstall +qall"

alias vg="vim Gemfile"

alias g='git'
alias gmerge="git checkout origin/master Gemfile.lock; bundle; git status"

# Creates a symbolic link to a file
# symlink /path/to/original/file /path/to/symlink
alias symlink="ln -s"

#alias new_pw='cd ~/Code/q-centrix/web; rails runner "puts SecureRandom.base64(32)"'
alias new_uuid='rails runner "p SecureRandom.uuid"'

alias be='bundle exec'
alias dbm='bundle exec rake db:migrate'
alias dbr='bundle exec rake db:rollback'
alias rgm='rails g active_record:migration'

# Javascript / React
alias react_regen_snaps='npm run test:spec -- -u'
alias react_format='npm run test:format'
alias react_format_and_test='react_format && react_test'
alias react_regen_snapshots='npm run test:spec -- -u'
alias react_single_test='npx jest --'
alias react_update="npm install"
alias react_update_storybook="npm update @storybook/addon-actions; npm update @storybook/addon-info; npm update @storybook/addon-knobs; npm update @storybook/addon-links; npm update @storybook/addon-viewport; npm update @storybook/addons; npm update @storybook/react"
alias react_test='npm run test'

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
  # eval "$(ssh-agent)" > /dev/null # We don't care about the output.
  ssh-add -l | grep "The agent has no identities" > /dev/null
  if [ $? -eq 0 ]; then
    ssh-add
  fi
}

# Reloads bashrc
function reload()
{
  export LAST_DIR=$(pwd) # Save the current working directory so we can switch back to it after reload.
  source ${HOME}/.bashrc
}

##### Ruby/Rails Aliases #####

# Pulls the Heroku db to local (requires name of local DB
alias get_heroku_db="rake db:drop; heroku pg:pull DATABASE_URL"

# Clears the rails cache.
alias rails_clear_cache="rails runner \"Rails.cache.clear\""

alias rails_server_process="lsof -wni tcp:3000"

alias rs="be rspec"

alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg-stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# Re-creates the database for dev with the production data dump.
function setup_dev_database()
(
  echo 'Dropping the database...'
  db=`rake db:drop 2&>1`
  run=`sed -n '/ERROR/p' <<< "$db"`
  if [ -n "$run" ]
  then
    echo 'hmm....'
    exit 1
  else
    echo 'Next steps...'
  fi
  rake db:create
  # with dump backup
  pg_restore --verbose --clean --no-acl --no-owner -d currica_development ~/Desktop/currica-db-small.dump
  # with S3 backup
  # psql -d currica_development < ~/Desktop/prodreplicadump_20170105_040002.sql
  rm 1
  rake db:migrate
  rake db:migrate RAILS_ENV=test
  rails runner '@user = User.find_by_email("rreas@q-centrix.com"); @user.password = "password1!"; @user.password_confirmation = "password1!"; @user.save!;'
  rm 1
)

function setup_dev_database_registries()
(
  rake db:drop
  rake db:create
  rake db:migrate
  rake db:migrate RAILS_ENV=test
  rake db:seed
  rails runner '@user = User.find_by_email("rreas@q-centrix.com"); @user.password = "password1!"; @user.password_confirmation = "password1!"; @user.save!;'
  rake ncdr:cath_pci:seed_questions
  rake ncdr:cath_pci:create_for_facility
  rake registries:update_edge_targets
  rake registries:seed_populators['cath_pci']
)

function reset_rreas_password()
(
  rails runner '@user = User.find_by_email("rreas@q-centrix.com"); @user.password = "password1!"; @user.password_confirmation = "password1!"; @user.save!;'
)

function setup_test_database()
(
  rake db:drop RAILS_ENV=test
  rake db:create RAILS_ENV=test
  rake db:migrate RAILS_ENV=test
)

# Re-creates the database for prod with the production data dump.
function setup_production_db()
(
  echo 'Dropping the database...'
  db=`rake db:drop 2&>1`
  run=`sed -n '/ERROR/p' <<< "$db"`
  if [ -n "$run" ]
  then
    echo 'hmm....'
    exit 1
  else
    echo 'Next steps...'
  fi
  rake db:create RAILS_ENV=production
  pg_restore --verbose --clean --no-acl --no-owner -d currica_production ~/Code/Work/currica/currica-db.dump
  rake db:migrate RAILS_ENV=production
  RAILS_ENV=production rails runner '@user = User.find_by_email("rreas@q-centrix.com"); @user.password = "password1!"; @user.password_confirmation = "password1!"; @user.save!;'
  rm 1
)

# 1 - snomed code
# 2 - visit ID
function find_code
{
  curr_dir=`pwd`
  dir="/Users/dillonwelch/OneDrive - Q-Centrix, LLC/wired/test bed data set/results/wired_round_2/qc2"
  cd "${dir}"
  find . -type f -print | grep ${2} | xargs grep ${1}
  cd "${curr_dir}"
  # find "/Users/dillonwelch/OneDrive - Q-Centrix, LLC/wired/test bed data set/results/wired_round_2/qc2" -type f -print | grep ${2} | xargs grep ${1}
}

function find_dys
{
  conds=('Dyslipidemia' 'Hyperlipidemia'
         'Lipid lowering agent' 'Statin'
         'Hyperchol' 'Calcium channel blocker'
         'Antilipemic agent' 'Oral hypoglycemic'
         'Cholesterol' 'LDL' 'HDL')

  codes=(370992007 55822004 373267003 96302009
         13644009 48698004 57952007 346597008
         '2093-3' '2089-1' '2085-9')
  len=${#conds[@]}

  for (( i=0; i<${len}; i++));
  do
    echo ${conds[$i]}
    find_code ${codes[$i]} ${1}
    echo ''
  done
}

function find_cvd
{
  conds=('CVD' 'TIA' 'Stroke')
  codes=(6291400 266257000 230690007)
  len=${#conds[@]}

  for (( i=0; i<${len}; i++));
  do
    echo ${conds[$i]}
    find_code ${codes[$i]} ${1}
    echo ''
  done
}

function find_replace
{
  # find ./ -type f -exec sed -i -e 's/${1}/${2}/g' {} \;
  # find ./ -type f -exec sed -i -e 's/FactoryGirl/FactoryBot/g' {} \;
  find ./ -type f -exec sed -i -e 's/ActiveRecord::Migration/ActiveRecord::Migration[4.2]/g' {} \;
  find . -name "*-e" -type f -delete
}


##### Startup Commands #####

# Changes directory on startup (DOES NOT change home directory).
cd $DEFAULTDIR

# If this is the first time loading the shell, go to default directory.
# Otherwise, go to the directory we were working in before reload
if [[ -z "$LAST_DIR" ]]; then cd $DEFAULTDIR; else cd "${LAST_DIR}"; fi

# Adds Git Auto-Complete.
source ~/git-completion.bash

set_up_ssh_agent

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# https://stackoverflow.com/a/42265848
# Required for GPG key signing to work
export GPG_TTY=$(tty)
