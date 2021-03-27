" If $MYVIMRC gets sourced twice, autocommands will be duplicated.
" Create a common 'vimrc' group to register autocmd under, and clear it here.
" Groups with different names must be cleared too.
augroup vimrc
  autocmd!
augroup END

let mapleader = ' '
let maplocalleader = ' '

" Use system clipboard for all operations.
set clipboard+=unnamedplus

" Enable mouse support.
set mouse=a

" Neovim enables autoread by default, which automatically updates the buffer
" if the file was modified externally on disk, by listening to various events
" like buffer focus. (It also prompts for reload if the buffer is modified.) 
" https://github.com/neovim/neovim/issues/1936
" Extend this to also handle the case of C-z -> fg.
" https://github.com/neovim/neovim/issues/3648
augroup vimrc
  autocmd VimResume * silent! checktime
augroup end

call plug#begin(stdpath('data') . '/plugged')

call plug#end()
