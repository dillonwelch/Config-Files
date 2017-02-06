rm $HOME/.bashrc
rm $HOME/.gemrc
rm $HOME/.gitconfig
rm $HOME/.gitignore
rm $HOME/.vimrc
rm $HOME/.vim/vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle.vim
ln -s .bashrc $HOME/.bashrc
ln -s .gemrc $HOME/.gemrc
ln -s .gitconfig $HOME/.gitconfig
ln -s .gitignore $HOME/.gitignore
ln -s .vimrc $HOME/.vimrc
ln -s .vim/vundle.vim $HOME/.vim/
ln -s .vim/rename_current_file.vim $HOME/.vim/
