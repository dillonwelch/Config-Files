rm $HOME/git-completion.bash
rm $HOME/.bashrc
rm $HOME/.gemrc
rm $HOME/.gitconfig
rm $HOME/.gitignore
rm $HOME/.vimrc
rm $HOME/.vim/rename_current_file.vim
rm $HOME/.vim/vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
DIR=`pwd`
ln -s $DIR/git-completion.bash $HOME/
ln -s $DIR/.bashrc $HOME/.bashrc
ln -s $DIR/.gemrc $HOME/.gemrc
ln -s $DIR/.gitconfig $HOME/.gitconfig
ln -s $DIR/.gitignore $HOME/.gitignore
ln -s $DIR/.vimrc $HOME/.vimrc
ln -s $DIR/.vim/rename_current_file.vim $HOME/.vim/
ln -s $DIR/.vim/vundle.vim $HOME/.vim/

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install pinentry-mac gpg npm postgresql redis vim
brew install imagemagick@6 && brew link imagemagick@6 --force # rmagick

# Heroku
brew install heroku/brew/heroku
heroku login
heroku keys:add

# RVM
gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
