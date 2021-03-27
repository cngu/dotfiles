" If $MYVIMRC gets sourced twice, autocommands will be duplicated - remove them.
augroup vimrc
  autocmd!
augroup END

let mapleader = ' '
let maplocalleader = ' '

" Use system clipboard for all operations.
set clipboard+=unnamedplus

" Enable mouse support.
set mouse=a

call plug#begin(stdpath('data') . '/plugged')

call plug#end()
