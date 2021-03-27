" ============================================================================
" Base Settings {{{
" ============================================================================
" If $MYVIMRC gets sourced twice, autocommands will be duplicated.
" Register autocommands under this common group for ease of clearing.
" Global autocommands and other groups must be cleared separately.
" https://vi.stackexchange.com/questions/15483/clear-all-autocommands
augroup vimrc
  autocmd!
augroup END

let mapleader = ' '
let maplocalleader = ' '

" Establish {{{ and }}} fold markers. Mainly used for this file.
set foldmethod=marker

" Persistent undo history between Neovim sessions.
set undofile

" Use system clipboard for all operations.
set clipboard+=unnamedplus

" Enable mouse support.
set mouse=a

set number relativenumber
augroup vimrc
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber 
augroup END

" Neovim enables autoread by default, which automatically updates the buffer
" if the file was modified externally on disk, by listening to various events
" like buffer focus. (It also prompts for reload if the buffer is modified.) 
" https://github.com/neovim/neovim/issues/1936
" Extend this to also handle the case of C-z -> fg.
" https://github.com/neovim/neovim/issues/3648
augroup vimrc
  autocmd VimResume * silent! checktime
augroup end
" }}}
" ============================================================================

" ============================================================================
" Plugins {{{
" ============================================================================
call plug#begin(stdpath('data') . '/plugged')

call plug#end()
" }}} 
" ============================================================================
