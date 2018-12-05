"
" Also see $VIMRUNTIME/vimrc_example.vim and $VIMRUNTIME/defaults.vim.
"
" ============================================================================
" VIM 8 DEFAULTS {{{
" ============================================================================
let s:darwin = has('mac')

" }}}
" ============================================================================
" VIM-PLUG {{{
" ============================================================================
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
nmap <c-p> :Files<CR>

Plug 'jremmen/vim-ripgrep'
let g:rg_highlight = 1
let g:rg_format = '%f:%l:%c:%m'

Plug 'junegunn/vim-slash'
" noremap <plug>(slash-after) zz
if has('timers')
  " Blink 2 times with 50ms interval
  noremap <expr> <plug>(slash-after) slash#blink(2, 50)
endif

Plug 'justinmk/vim-gtfo'
Plug 'tpope/vim-fugitive'
if s:darwin
  Plug 'junegunn/vim-xmark'
endif

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-surround'

Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
augroup nerd_loader
  autocmd!
  autocmd VimEnter * silent! autocmd! FileExplorer
  autocmd BufEnter,BufNew *
        \  if isdirectory(expand('<amatch>'))
        \|   call plug#load('nerdtree')
        \|   execute 'autocmd! nerd_loader'
        \| endif
augroup END

Plug 'Yggdroot/indentLine'
" let g:indentLine_char = '⎸'
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

Plug 'itchyny/lightline.vim'
let g:lightline = { 
  \ 'colorscheme': 'one',
  \ 'active': {
  \   'left': [ 
  \     [ 'mode', 'paste' ],
  \     [ 'readonly', 'relativepath', 'modified' ] 
  \   ],
  \   'right': [ 
  \     [ 'lineinfo' ],
  \     [ 'percent' ],
  \     [ 'gitbranch', 'fileformat', 'fileencoding', 'filetype' ] 
  \   ]
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head'
  \ }
\ }
set laststatus=2
set noshowmode

Plug 'rakr/vim-one'

call plug#end()

if has('gui_running')
  syntax on
  syntax enable
  set background=dark
  colorscheme one
endif
" }}}
" ============================================================================
" BASIC SETTINGS {{{
" ============================================================================
set encoding=utf-8
set number relativenumber " line number
set ruler " column number
set colorcolumn=100

set backspace=indent,eol,start
set clipboard=unnamed

set tabstop=2
set shiftwidth=2
set expandtab smarttab

set foldmethod=marker 
set nofoldenable
set nomodeline

set incsearch " Highlight search match as I type, but won't keep them highlighted
set hlsearch

hi QuickFixLine guibg=Black
" hi Search guibg=LightYellow guifg=Red

" set visualbell

" Move lines up and down with <A-k> and <A-j>
" nnoremap ∆ :m .+1<CR>==
" nnoremap ˚ :m .-2<CR>==
" inoremap ∆ <Esc>:m .+1<CR>==gi
" inoremap ˚ <Esc>:m .-2<CR>==gi
" vnoremap ∆ :m '>+1<CR>gv=gv
" vnoremap ˚ :m '<-2<CR>gv=gv

nnoremap p p=`]

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Show command as it's being typed
set showcmd
set ignorecase smartcase

set hidden " Allow switching buffers even if the current one isn't saved.

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" grep
set grepprg=rg\ -F\ -S\ --no-heading\ --vimgrep

" Strip trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd FileType c,cpp,java,javascript,python,vue autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" vim-vue & vim-commentary
" Author's recommendation to fix bug where highlighting stops working randomly
autocmd FileType vue syntax sync fromstart
autocmd FileType vue setlocal commentstring=\/\/\ %s
let g:vue_disable_pre_processors=1

" Sync cursor color to (vim-one, not bubblegum) Airline color
highlight Cursor guibg=#99C27C
" hi Visual guifg=#000000 guibg=#C57BDB
autocmd InsertEnter * highlight  Cursor guibg=#65B0ED
autocmd InsertEnter * highlight  CursorLine guibg=#2F3244
autocmd InsertLeave * highlight  Cursor guibg=#99C27C 
autocmd InsertLeave * highlight  CursorLine guibg=#2C323C

" }}}
" ============================================================================
" PRETTY PRINT FUNCTIONS {{{
" ============================================================================
command! PrettyJSON execute "%!python -m json.tool"
function! DoFormatXML() range
	" Save the file type
	let l:origft = &ft

	" Clean the file type
	set ft=

	" Add fake initial tag (so we can process multiple top-level elements)
	exe ":let l:beforeFirstLine=" . a:firstline . "-1"
	if l:beforeFirstLine < 0
		let l:beforeFirstLine=0
	endif
	exe a:lastline . "put ='</PrettyXML>'"
	exe l:beforeFirstLine . "put ='<PrettyXML>'"
	exe ":let l:newLastLine=" . a:lastline . "+2"
	if l:newLastLine > line('$')
		let l:newLastLine=line('$')
	endif

	" Remove XML header
	exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

	" Recalculate last line of the edited code
	let l:newLastLine=search('</PrettyXML>')

	" Execute external formatter
	exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

	" Recalculate first and last lines of the edited code
	let l:newFirstLine=search('<PrettyXML>')
	let l:newLastLine=search('</PrettyXML>')
	
	" Get inner range
	let l:innerFirstLine=l:newFirstLine+1
	let l:innerLastLine=l:newLastLine-1

	" Remove extra unnecessary indentation
	exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

	" Remove fake tag
	exe l:newLastLine . "d"
	exe l:newFirstLine . "d"

	" Put the cursor at the first line of the edited code
	exe ":" . l:newFirstLine

	" Restore the file type
	exe "set ft=" . l:origft
endfunction
command! -range=% PrettyXML <line1>,<line2>call DoFormatXML()
" }}}
