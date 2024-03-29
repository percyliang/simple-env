" Basic settings
set autoindent
set tabstop=2 shiftwidth=2
set nowrap
set textwidth=0            " Don't wrap the text at all
set hidden                 " A buffer is not closed when another is brought up, just put in the background
set smarttab               " Tab the shiftwidth, not the tabstop (useful if I don't want tab indents)
set expandtab              " Turn all tabs into spaces
"set background=dark       " Let's not go blind when the background is dark
set background=light       " For light background
set noswapfile             " Get rid of annoying swap files
set incsearch              " Search as you type
set nohlsearch             " Don't highlight search results
set timeoutlen=500
set visualbell             " Don't make beeps
set backspace=start,indent " Allow backspacing through tabs at the beginning of a program
set ruler                  " Shows current position in file
set nostartofline          " When jump to another location, keep same column
set indentkeys=            " Disable this annoying feature
set noignorecase

set viminfo="NONE"

set directory=~/tmp        " MacOS X keeps on wiping /tmp, so use ~/tmp instead

syntax on
filetype plugin on
filetype plugin indent on
let java_allow_cpp_keywords=1 " Don't complain about using keywords like delete
let java_ignore_javadoc=1 " Don't make javadoc look special.
let b:did_ftplugin=1 " Don't use annoying SQL plugin.

" Previous buffer
map <C-P> :MiniBufExplorer<CR><S-TAB><CR>
" Next buffer
map <C-N> :MiniBufExplorer<CR><TAB><CR>
" Kill buffer
map <C-\> :bd<CR>
" Go back to last spot (Ctrl-O is already taken by the meta key in screen)
map <C-K> <C-O>

" Copy and paste across vim sessions
map qy :w !xclip -sel clip<CR>
map qp :r !xclip -sel clip -o<CR>

" Print current date
map qd :r !date +\%Y-\%m-\%d<CR>I{<ESC>A}<ESC>
" Print current time
map qt :r !date +\%H:\%M:\%S<CR><ESC>kJ

" Remove trailing whitespace
map qw :%s/ *$//g<CR>

" Put in comment
map qc i\pl{} <LEFT><LEFT>

au BufRead,BufNewFile *.py setlocal shiftwidth=4 tabstop=4

" Show trailing whitespace as ugly red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Find a file
map qf :e nav<CR>/\c
map qg <C-W>k/\c

" Allow editing gpg files directly (symmetric encryption)
" Note: doesn't put a newline at the end of the file.
augroup encrypted
  au!
  " Disable swap files, and set binary file format before reading the file
  autocmd BufReadPre,FileReadPre *.gpg
    \ setlocal noswapfile bin
  " Decrypt the contents after reading the file, reset binary file format
  " and run any BufReadPost autocmds matching the file name without the .gpg
  " extension
  autocmd BufReadPost,FileReadPost *.gpg
    \ execute "'[,']!gpg --decrypt 2>/dev/null" |
    \ setlocal nobin |
    \ execute "doautocmd BufReadPost " . expand("%:r")
  " Set binary file format and encrypt the contents before writing the file
  autocmd BufWritePre,FileWritePre *.gpg
    \ setlocal bin |
    \ '[,']!gpg --symmetric
  " After writing the file, do an :undo to revert the encryption in the
  " buffer, and reset binary file format
  autocmd BufWritePost,FileWritePost *.gpg
    \ silent u |
    \ setlocal nobin
augroup END

map qx :call ExecCurrentItem()<CR>
function! ExecCurrentItem()
  let command="!cd `dirname %` && (".escape(substitute(getline(line(".")), '#.*$', '', ''), "%#").")"
  exec command
endfunction
