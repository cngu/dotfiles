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
  autocmd InsertEnter * set norelativenumber
  autocmd InsertLeave * set relativenumber
augroup END

" Max line width hint
augroup vimrc
  autocmd FileType,WinEnter *
    \ if &ft == 'vim'
      \ | setlocal colorcolumn=79
    \ | elseif &ft != 'help'
      \ | setlocal colorcolumn=121
    \ | endif
  autocmd WinLeave * setlocal colorcolumn=0
augroup END

" Strip trailing whitespace on save.
augroup vimrc
  function! s:StripTrailingWhitespace() abort
    " The substitution moves the cursor position to each matching line.
    " So cache and restore cursor position to avoid jumping.
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    call cursor(l, c)
  endfunction
  autocmd BufWritePre * :call s:StripTrailingWhitespace()
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

" NOTE: vim-polyglot uses vim-vue, which is very slow on vue files
let g:vue_pre_processors = ['pug', 'scss']
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'

Plug 'junegunn/vim-slash'
if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

Plug 'tpope/vim-fugitive'

call plug#end()
" }}}
" ============================================================================

" ============================================================================
" Colorscheme {{{
" ============================================================================
set termguicolors

colorscheme onedark
source ~/.config/nvim/statusline.vim

" }}}
" ============================================================================

" ============================================================================
" Utilities {{{
" ============================================================================
command PrettyJSON execute "%!jq ."
command PrettyHTML execute "%!tidy -iq --show-warnings no --tidy-mark no --preserve-entities yes --coerce-endtags no -wrap 0"
command PrettyXML execute "%!tidy -xml -iq --show-warnings no --preserve-entities yes -wrap"
" }}}
" ============================================================================
