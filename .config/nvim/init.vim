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
let g:vim_indent_cont = &shiftwidth

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
    \ if &ft ==# 'vim'
      \ | setlocal colorcolumn=79
    \ | elseif &ft !=# 'help'
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

Plug 'tpope/vim-fugitive'

Plug 'junegunn/vim-slash'
if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

Plug 'tpope/vim-commentary'

" vim-polyglot uses vim-vue by edefault, but we use install vim-vue-plugin
" instead for better vim-commentary integration, better syntax highlighting,
" and it's much faster when navigating (e.g. gg, G). downside is a flash of no
" highlighting when first opening a vue file. And when launching vim with
" multiple files (-O), non-active windows are not highlighted until you :e
let g:vue_pre_processors = []
let g:polyglot_disabled = ['vue']
Plug 'sheerun/vim-polyglot'

let g:vim_vue_plugin_config = {
  \ 'syntax': {
  \   'template': ['html', 'pug'],
  \   'script': ['javascript', 'typescript'],
  \   'style': ['scss']
  \ },
  \ 'full_syntax': [],
  \ 'attribute': 0,
  \ 'keyword': 1,
  \ 'foldexpr': 0,
  \ 'init_indent': 0,
  \ 'debug': 0
\ }
function! OnChangeVueSubtype(subtype)
  " https://github.com/leafOfTree/vim-vue-plugin/issues/26
  " https://github.com/digitaltoad/vim-pug/issues/103
  " echom 'subtype is '.a:subtype
  if a:subtype ==# 'pug'
    setlocal commentstring=//-\ %s
    setlocal comments=://-,:// commentstring=//-\ %s
  elseif a:subtype ==# 'html'
    setlocal commentstring=<!--%s-->
    setlocal comments=s:<!--,m:\ \ \ \ ,e:-->
  elseif a:subtype =~ 'css'
    setlocal comments=s1:/*,mb:*,ex:*/ commentstring&
  else
    setlocal commentstring=//%s
    setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
  endif
endfunction
Plug 'leafOfTree/vim-vue-plugin', { 'for': 'vue' }

Plug 'joshdick/onedark.vim'

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

command ProfileStart
  \ execute 'profile start profile.log'
  \ | execute 'profile file *'
  \ | execute 'profile func *'
command ProfileEnd execute 'profile stop'
" }}}
" ============================================================================
