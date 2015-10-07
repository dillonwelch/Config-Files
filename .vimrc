""""""
" Vundle
""""""
" Required for Vundle.
set nocompatible
" Separate file for Vundle packages
source $HOME/.vim/vundle.vim

" Enable filetype detection and filetype specific settings.
filetype on
filetype indent on
filetype plugin on

" Set Rubocop file
let g:vimrubocop_config = '~/Code/Work/currica/hound/config/style_guides/ruby.yml'

" Show hidden files in Ctrl-P
let g:ctrlp_show_hidden = 1

" Watch for gems.tags files in addition to tags.
set tags+=gems.tags

"""""
" Plugin Aliases
""""
" Rename current file (courtesy of Gary Bernhardt)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>n :call RenameFile()<cr>
map <Leader>m :CtrlPTag<cr>

set wildignore+=*.o,tmp

"""""
" Aliases
"""""
cabbr <expr> MyVundle expand('~/.vim/vundle.vim')
command! EBashRC e ~/.bashrc
command! EVundle e ~/.vim/vundle.vim
command! EVimRC e $MYVIMRC

" From https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

""""""
" Display
""""""
" Enables syntax highlighting
syntax enable
" Shows line numbers
set number
"Highlight cursor line and column
set cursorline
set cursorcolumn
"Flash matching bracket on insert
set showmatch
"Always display status bar
set laststatus=2
set ruler
"Highlight search terms as they are matched
set incsearch
"Highlight matched search pattern
set hlsearch
"Case insensitive search unless caps are used
set ignorecase smartcase
"Show commands as I type them.
set showcmd
"Displays a column at 80 characters
set colorcolumn=80

"""
" Functionality
"""
"Set title to current file name
set title
"Allows backspacing over everything
set backspace=indent,eol,start
"Make all swap files in a temp folder with an absolute directroy name (so swap files with the same names don't get overwritten.
set dir=/tmp
"Don't put cursor at start of the line unnecessarily (test)
set nostartofline
"Enhanced tab completion
set wildmenu
"Set working dir to main dir. Use %:p:h to get file dir.
cd ~
"Global search/replace by default
set gdefault
"Enter newlines without entering insert mode. Moves cursor to new line.
"""Shift-Enter to insert above.
nmap <S-Enter> O<Esc>
"""Enter to insert below.
nmap <CR> o<Esc>
""" Opens a file in the current directory.
cabbr <expr> %% expand('%:p:h')
"Allows copying to the clipboard for Macs.
map <F2> :.w !pbcopy<CR><CR>
"Allows pasting from clipboard for Macs.
map <F3> :r !pbpaste<CR>
"Prompt to save (if unsaved changes) when quitting.
set confirm

"""
" Indentation
"""
" Sets two-character space tabs
set expandtab
set tabstop=4
set softtabstop=2
set shiftwidth=2

" Sets reverse tab in insert mode
"imap <S-Tab> <Esc><<i
" Sets tab and reverse tab in various modes.
imap <S-Tab> <backspace>
vmap <tab> >
vmap <s-tab> <
nmap <tab><tab> >>
nmap <s-tab><s-tab> <<

" Auto-indent
set noautoindent smartindent

"""
" File Format
"""
" Sets the file format to use unix line endings for new buffers, and read in either unix or dos files.
set ffs=unix,dos

"""
" Functions
"""

" Replace foo(blah, number) with foo(blah, const)
function! ReplaceFooParam(number, const)
  " All of the possible characters that can be inside.
  let word = ['\w', '\d', '\s', '\$', ':', '-', '\[', '\]', '''', '\.', '\/', '"', '>']

  " Search for foo, followed by an optional _list.
  "TODO: make function name a param
  "TODO: Split this up on lines and comment like crazy.
  exec '%s/\<\(foo\(_list\)*' .
  \ '(\' .
  \ '(' . join(word, '\|') . '\)*\((\(' . join(word, '\|') . '\|,\)*)\)*\), ' . a:number . '/\1, ' . a:const . '/ce'

endfunction

function! ReplaceBarParam(number, const)
  "TODO: make function name a param
  exec '%s/\(bar(''\(\w\)*''\), ' . a:number . '/\1, ' . a:const . '/ce'

endfunction

" A wrapper function to restore the cursor position, window position,
" and last search after running a command.
function! Preserve(command)
  " Save the last search
  let last_search=@/
  " Save the current cursor position
  let save_cursor = getpos(".")
  " Save the window position
  normal H
  let save_window = getpos(".")
  call setpos('.', save_cursor)

  " Do the business:
  exec 'call ' . a:command . '()'

  " Restore the last_search
  let @/=last_search
  " Restore the window position
  call setpos('.', save_window)
  normal zt
  " Restore the cursor position
  call setpos('.', save_cursor)
endfunction

" Converts all newlines to Unix style.
function! UnixNewlines()
  e ++ff=dos
  setlocal ff=unix
  w
endfunction

" Removes trailing whitespace and blank EOF lines.
function! StripWhitespace()
  " Removes trailing whitespace.
  %s/\s\+$//e
  " Removes blank EOFs.
  silent! %s#\($\n\s*\)\+\%$##
endfunction

function! ApplySyntaxSettings()
endfunction

"""
" On Open/Save
"""
" Do things when the file is written out.
au BufWritePre * call Preserve("StripWhitespace")

" Read axlsx view files as ruby files.
au BufReadPost *.axlsx set syntax=ruby

" Automatically sources .vimrc after saving it.
autocmd! bufwritepost .vimrc source %

" Automatically source .vimrc and runs BundleUpdate when saving vundle.vim.
autocmd! bufwritepost vundle.vim source .vimrc | BundleInstall
