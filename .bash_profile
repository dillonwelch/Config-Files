
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

source "$HOME/.bashrc"
source "$HOME/.profile"

pg-start 2>1 1>/dev/null
