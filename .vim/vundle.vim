" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle (required)!
Plugin 'gmarik/Vundle.vim'

"""" Ruby/Rails plugins
" Adds Rails navigation, generator, and other commands.
Plugin 'tpope/vim-rails'

" Adds Ruby navigation and syntax highlighting.
Plugin 'vim-ruby/vim-ruby'

" Adds Bundle support.
" Plugin 'tpope/vim-bundler'

" Add CoffeeScript support
Plugin 'kchmck/vim-coffee-script'

" Runs Rubocop in Vim
Plugin 'ngmy/vim-rubocop'

"""" End Ruby plugins

" Autocompletes endings for control structures in Ruby, C, and other languages.
Plugin 'tpope/vim-endwise'

" Code Completion engine for many languages
" Plugin 'Valloric/YouCompleteMe'
Plugin 'Shougo/neocomplete'
" Plugin 'osyo-manga/vim-monster'

" Autocomplete filenames with fuzzy file search
" Plugin 'wincent/Command-T'
Plugin 'ctrlpvim/ctrlp.vim'

" :Nyancat for an awesome surprise!
" Plugin 'koron/nyancat-vim'

" Adds directory navigation.
" Plugin 'scrooloose/nerdtree'

" Git wrapper for Vim.
" Plugin 'tpope/vim-fugitive'

" Toggle commenting, currently aliased to <leader>gc
Plugin 'tomtom/tcomment_vim'

" Extend the dot macro by letting plugins use it
Plugin 'tpope/vim-repeat'

" Easily add surroundings in normal mode
Plugin 'tpope/vim-surround'

" Extra keymappings using brackets
Plugin 'tpope/vim-unimpaired'

call vundle#end()
