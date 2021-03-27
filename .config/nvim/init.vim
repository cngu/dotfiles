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

" Establish {{{ and }}} fold markers. Mainly used for this file.
" Expand all folds by default.
set foldmethod=marker
set nofoldenable

" Persistent undo history between Neovim sessions.
set undofile

" Use system clipboard for all operations.
set clipboard+=unnamedplus

" Enable mouse support.
set mouse=a

" Allow switching buffers even if the current one isn't saved.
set hidden

set tabstop=2
set shiftwidth=2
set expandtab

" Case-sensitive search if query includes caps; otherwise case-insensitive.
set ignorecase
set smartcase

" Show absolute line numbers in insert mode; otherwise relative.
set number
set relativenumber
augroup vimrc
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
augroup END

" Max line width hint
augroup vimrc
  autocmd FileType *
    \ if &ft == 'vim'
      \ | setlocal colorcolumn=79
    \ | elseif &ft != 'help'
      \ | setlocal colorcolumn=121
    \ | endif
augroup END

" Strip trailing whitespace on save.
augroup vimrc
  autocmd BufWritePre * %s/\s\+$//e
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
" Key Mappings {{{
" ============================================================================
" Tip: In insert or command mode, hit CTRL+v and hit a key sequence to see it.

let mapleader = ' '
let maplocalleader = ' '

" Do not yank on the following operations
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C
nnoremap s "_s
vnoremap s "_s
nnoremap S "_S
vnoremap S "_S
nnoremap x "_x
vnoremap x "_x
nnoremap X "_X
vnoremap X "_X
vnoremap R "_R
vnoremap <leader>p "_dP

" Option+Left/Right to navigate by word in command mode.
" Option+Left/Right+Backspace to delete word before cursor.
" https://stackoverflow.com/a/21207170/5095212
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-BS> <C-w>
" }}}
" ============================================================================

" ============================================================================
" Plugins {{{
" ============================================================================
call plug#begin(stdpath('data') . '/plugged')

call plug#end()
" }}}
" ============================================================================

" ============================================================================
" Utilities {{{
" ============================================================================
command PrettyJSON execute "%!jq ."
" }}}
" ============================================================================
