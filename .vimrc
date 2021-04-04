"
" Also see $VIMRUNTIME/vimrc_example.vim and $VIMRUNTIME/defaults.vim.
"
" ============================================================================
" Vim 8 Defaults {{{
" ============================================================================
unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

augroup vimrc
  autocmd!
augroup END

" let s:darwin = has('mac')
" let s:windows = has('win32') || has('win64')

let mapleader = ' '
let maplocalleader = ' '

" Put all swap and undo files in /tmp. Cleaner, but riskier.
set backupdir=/tmp//,.
set directory=/tmp//,.
if has('persistent_undo')
  set undodir=/tmp,.
  set undofile
endif
" }}}
" ============================================================================
" Plugins {{{
" ============================================================================
call plug#begin('~/.vim/plugged')
Plug 'justinmk/vim-gtfo'
Plug 'tpope/vim-commentary'
  autocmd FileType vue setlocal commentstring=\/\/\ %s
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Yggdroot/indentLine'

Plug 'rakr/vim-one'

Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
  let g:javascript_plugin_jsdoc = 1
Plug 'posva/vim-vue'
  " Author's recommendation to fix bug where highlighting stops working randomly
  let g:vue_pre_processors = []
Plug 'elzr/vim-json'
  let g:vim_json_syntax_conceal = 0

Plug 'cngu/vim-vinegar'
  let g:netrw_banner = 0
  let g:netrw_liststyle = 0
  let g:netrw_winsize = 25

Plug 'junegunn/vim-slash'
  set shortmess-=S
  set shortmess+=s
  if has('timers')
    " Blink 2 times with 50ms interval
    noremap <expr> <plug>(slash-after) slash#blink(2, 50)
  endif

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
  command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  nnoremap <Leader>f :Files<CR>
  nnoremap <C-p> :Files<CR>
  " Disable floating popup window due to issue where lightline disappears after
  " opening the fzf popup window. It only re-appears after switching buffers.
  " Try updating plugins to see if it is fixed.  If so, uncomment.
  " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Todo', 'border': 'rounded' } }

" empty q-args check to make sure `:Rg` (i.e. without search query) executes `rg ''` (to match every single line)
" enter:select-all+accept
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --pcre2 --column --line-number --no-heading --color=always --smart-case --follow --hidden --glob !.git '.(empty(<q-args>) ? "''" : <q-args>), 1,
      \   fzf#vim#with_preview({
      \     'options': ['--no-sort', '--bind', 'ctrl-a:select-all,ctrl-d:deselect-all']
      \   }), <bang>0)
nnoremap <Leader>s :Rg<Space>
nnoremap <Leader>* :Rg -w <C-R><C-W><CR>
nnoremap <Leader>g* :Rg <C-R><C-W><CR>

Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
  function! s:wipeout_inactive_buffers()
      "From tabpagebuflist() help, get a list of all buffers in all tabs
      let tablist = []
      for i in range(tabpagenr('$'))
          call extend(tablist, tabpagebuflist(i + 1))
      endfor

      "Below originally inspired by Hara Krishna Dara and Keith Roberts
      "http://tech.groups.yahoo.com/group/vim/message/56425
      let nWipeouts = 0
      for i in range(1, bufnr('$'))
          if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
          "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
              silent exec 'bwipeout' i
              let nWipeouts = nWipeouts + 1
          endif
      endfor
      echomsg nWipeouts . ' buffer(s) wiped out'
  endfunction
  function! s:format_buffer(b)
    let l:name = bufname(a:b)
    return printf("%s\t%s", a:b, empty(l:name) ? '[No Name]' : fnamemodify(l:name, ":p:~:."))
  endfunction
  function! s:wipeout_selected_buffers()
    return fzf#run(fzf#wrap({
          \ 'source':  map(
          \   filter(
          \     range(1, bufnr('$')),
          \     {_, nr -> buflisted(nr) && getbufvar(nr, "&filetype") != "qf" && !getbufvar(nr, "&modified")}
          \   ),
          \   {_, nr -> s:format_buffer(nr)}
          \ ),
          \ 'sink*': {lines -> execute('bwipeout '.join(map(lines, {_, line -> split(line)[0]})), '')},
          \ 'options': ['-m', '--tiebreak=index', '--ansi', '-d', '\t', '--prompt', 'Wipeout> ']
          \}))
  endfunction
  nnoremap <silent> <Leader>bw :<C-u>call <SID>wipeout_selected_buffers()<CR>
  nnoremap <silent> <Leader>bc :call <SID>wipeout_inactive_buffers()<CR>
  nnoremap <Leader>bb :Buffers<CR>
  nnoremap <Leader>bd :Sayonara!<CR>

Plug 'itchyny/lightline.vim'
  set laststatus=2
  set noshowmode
  let g:lightline = {
    \ 'colorscheme': 'one',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'readonly', 'relativepath', 'modified' ]
    \   ],
    \   'right': [
    \     [ 'lineinfo' ],
    \     [ 'gitbranch', 'fileencoding' ]
    \   ]
    \ },
    \ 'inactive': {
    \   'left': [
    \     [ 'relativepath', 'modified' ]
    \   ],
    \   'right': [
    \     [ 'lineinfo' ]
    \   ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'LightlineGitBranch',
    \   'fileencoding': 'LightlineFileencoding'
    \ }
  \ }
  function LightlineGitBranch()
    return winwidth(0) >= 124 ? fugitive#head() : ''
  endfunction
  function LightlineFileencoding()
    return winwidth(0) >= 124 ? &fileencoding : ''
  endfunction

Plug 'vimwiki/vimwiki'
  " Not sure why vimwiki needs this.  Disable for now because it messes with shortmess (and more).
  " set nocompatible
  filetype plugin on
  let g:vimwiki_list = [{'path': '~/Google Drive/vimwiki/',
                        \ 'syntax': 'markdown', 'ext': '.md'}]
call plug#end()
" }}}
" ============================================================================
" Base Settings {{{
" ============================================================================
set encoding=utf-8
set backspace=indent,eol,start
set clipboard=unnamed
set showcmd
set hidden " Allow switching buffers even if the current one isn't saved.

syntax enable
set background=dark
colorscheme one
if !has('gui_running')
  "Change ctermbg black (16) background to #303030
  call one#highlight('Normal', '', '303030', 'none')
endif
set guifont=MesloLGS\ NF:h12
set hlsearch
set incsearch " Highlight search match as I type, but won't keep them highlighted

set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set ruler " line and column number at cursor
set colorcolumn=120
set tabstop=2
set shiftwidth=2
set expandtab smarttab
set ignorecase smartcase

set foldmethod=marker
set nofoldenable
set nomodeline

nnoremap p p=`]
vnoremap p "_dP`[v`]=

nnoremap x "_x
vnoremap x "_x

" Strip trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd FileType c,cpp,java,javascript,python,vue autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
" }}}
" ============================================================================
" Quickfix {{{
" ============================================================================
" Always open quickfix window along entire bottom edge
autocmd FileType qf wincmd J

hi QuickFixLine guibg=Black
" }}}
" ============================================================================
" Cursor {{{
" ============================================================================
" Customize cursor shape and color
if has('gui_running')
  " Sync cursor color to (vim-one, not bubblegum) Airline color
  highlight Cursor guibg=#99C27C
  " hi Visual guifg=#000000 guibg=#C57BDB
  autocmd InsertEnter * highlight  Cursor guibg=#65B0ED
  autocmd InsertEnter * highlight  CursorLine guibg=#2F3244
  autocmd InsertLeave * highlight  Cursor guibg=#99C27C
  autocmd InsertLeave * highlight  CursorLine guibg=#2C323C
else
  let &t_SI = "\e[5 q" " SI=INSERT mode, 5=blinking bar
  let &t_EI = "\e[1 q" " EI=ELSE catch-all mode, 1=solid block
endif
" }}}
" ============================================================================
" Pretty Print {{{
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
