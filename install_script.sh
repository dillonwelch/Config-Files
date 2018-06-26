rm $HOME/.bashrc
rm $HOME/.gemrc
rm $HOME/.gitconfig
rm $HOME/.gitignore
rm $HOME/.vimrc
rm $HOME/.vim/vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
DIR=`pwd`
ln -s $DIR/.bashrc $HOME/.bashrc
ln -s $DIR/.gemrc $HOME/.gemrc
ln -s $DIR/.gitconfig $HOME/.gitconfig
ln -s $DIR/.gitignore $HOME/.gitignore
ln -s $DIR/.vimrc $HOME/.vimrc
ln -s $DIR/.vim/vundle.vim $HOME/.vim/
ln -s $DIR/.vim/rename_current_file.vim $HOME/.vim/
