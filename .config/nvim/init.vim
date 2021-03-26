" If $MYVIMRC gets sourced twice, autocommands will be duplicated - remove them.
augroup vimrc
  autocmd!
augroup END

let mapleader = ' '
let maplocalleader = ' '

call plug#begin(stdpath('data') . '/plugged')

call plug#end()
