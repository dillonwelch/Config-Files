" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)!
Plugin 'gmarik/vundle'

" Add CoffeeScript support
Plugin 'kchmck/vim-coffee-script'

"""" Ruby plugins
Plugin 'tpope/vim-rails'

call vundle#end()
filetype plugin indent on

syntax enable
