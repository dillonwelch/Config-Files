""""""
" Display
""""""
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
"Highlight to-do notes
highlight Todo ctermfg=darkgrey ctermbg=yellow
"Sets spellcheck on
set spell spelllang=en_us

"""
" Functionality
"""
"Set title to current file name
set title
"Allows backspacing over everything
set backspace=indent,eol,start
"Make all swap files in a temp folder with an absolute directroy name (so swap files with the same names don't get overwritten.
set dir=d://tmp//
"Don't put cursor at start of the line unnecessarily (test)
set nostartofline
"Enhanced tab completion
set wildmenu
"Set working dir to main dir. Use %:p:h to get file dir.
cd D:\
"Global search/replace by default
set gdefault
"Enter newlines without entering insert mode. Moves cursor to new line.
"""Shift-Enter to insert above.
nmap <S-Enter> O<Esc>
"""Enter to insert below.
nmap <CR> o<Esc>
""" Opens a file in the current directory.
cabbr <expr> %% expand('%:p:h')

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

" Replace quote(blah, number) with quote(blah, const)
function! ReplaceQuoteParam(number, const)
  " All of the possible characters that can be inside.
  let word = ['\w', '\d', '\s', '\$', ':', '-', '\[', '\]', '''', '\.', '\/', '"', '>']

  " Search for quote, followed by an optional _list.
  "TODO: Split this up on lines and comment like crazy.
  exec '%s/\<\(quote\(_list\)*' .
  \ '(\' .
  \ '(' . join(word, '\|') . '\)*\((\(' . join(word, '\|') . '\|,\)*)\)*\), ' . a:number . '/\1, ' . a:const . '/ce'

endfunction

" Replace m_quote(blah, number) with quote(blah, const)
function! ReplaceMongoQuoteParam(number, const)
  " All of the possible characters that can be inside.
  let word = ['\w', '\d', '\s', '\$', ':', '-', '\[', '\]', '''', '\.', '\/', '"', '>']

  " Search for quote, followed by an optional _list.
  "TODO: Split this up on lines and comment like crazy.
  exec '%s/\(m_quote\(_list\)*' .
  \ '(\' .
  \ '(' . join(word, '\|') . '\)*\((\(' . join(word, '\|') . '\|,\)*)\)*\), ' . a:number . '/\1, ' . a:const . '/ce'
endfunction

function! ReplaceWfrequestParam(number, const)

  exec '%s/\(wfrequest(''\(\w\)*''\), ' . a:number . '/\1, ' . a:const . '/ce'

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
  syntax enable
endfunction

" Things to do when the file is read
function! OnBufRead()
  " Change the newlines to Unix style.
  call UnixNewlines()
  " Enable syntax highlighting.
  "call ApplySyntaxSettings()
endfunction

function! ReplaceStuff()

  call ReplaceQuoteParam(0, 'WF_STRING')
  call ReplaceQuoteParam(1, 'WF_NUMERIC')
  call ReplaceQuoteParam(2, 'WF_DATE_INSERT')
  call ReplaceQuoteParam(3, 'WF_DATE_WHERE')
  call ReplaceQuoteParam(4, 'WF_BOOLEAN')

  call ReplaceMongoQuoteParam(0, 'MONGO_STRING')
  call ReplaceMongoQuoteParam(1, 'MONGO_INTEGER')
  call ReplaceMongoQuoteParam(2, 'MONGO_FLOAT')
  call ReplaceMongoQuoteParam(3, 'MONGO_DATE')
  call ReplaceMongoQuoteParam(4, 'MONGO_BOOLEAN')
  call ReplaceMongoQuoteParam(5, 'MONGO_OBJECT_ID')

  call ReplaceWfrequestParam(0, 'WF_STRING')
  call ReplaceWfrequestParam(1, 'WF_NUMERIC')
  call ReplaceWfrequestParam(4, 'WF_BOOLEAN')

  " Removes the version tag.
  exec '%s/ \* @version   SVN: \$Id\$\n//ce'

endfunction

"""
" On Open/Save
"""
" Do things when the a file is read in.
call ApplySyntaxSettings()

" Do things when the file is written out.
au BufWritePre * call Preserve("StripWhitespace")
au BufWritePre *.php call Preserve("ReplaceStuff")
