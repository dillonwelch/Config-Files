" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)!
Plugin 'gmarik/vundle'

" Add CoffeeScript support
Plugin 'kchmck/vim-coffee-script'

"""" Ruby plugins
" Adds Rails navigation, generator, and other commands.
Plugin 'tpope/vim-rails'

" Adds Ruby navigation and syntax highlighting
Plugin 'vim-ruby/vim-ruby'

"""" End Ruby plugins

" Adds directory navigation.
Plugin 'scrooloose/nerdtree'

" Git wrapper for Vim.
Plugin 'tpope/vim-fugitive'

call vundle#end()
