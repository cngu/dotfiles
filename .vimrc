set tabstop=2       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=2    " Indents will have a width of 4
set softtabstop=2   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces

set encoding=utf-8

set clipboard=unnamed

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Show command as it's being typed
set showcmd

" Show line numbers
set number

set ignorecase
set smartcase

" Force backspace to work on...
" - indent: indentation
" - eol: EOL characters
" - start: text that wasn't typed in the current insert mode session.
set backspace=indent,eol,start

" Highlight search match as I type, but won't keep them highlighted
set incsearch

" Allow switching buffers even if the current one isn't saved.
set hidden

" Keymaps
nmap <c-p> :Files<CR>

" Styling
"highlight MatchParen cterm=bold ctermbg=lightblue

" vim-plug
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/libs/fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

Plug 'posva/vim-vue'
Plug 'pangloss/vim-javascript'
"Plug 'digitaltoad/vim-pug'
"Plug 'othree/html5.vim'

"Plug 'chriskempson/base16-vim'
Plug 'rakr/vim-one'

"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Color Scheme
if has('gui_running')
  syntax enable

  set background=dark
  colorscheme one
  
  " colorscheme base16-materia
  " colorscheme base16-material
  " colorscheme base16-eighties
endif

"set guifont=Droid\ Sans\ Mono\ for\ Powerline
"let g:airline_theme='bubblegum'
"let g:airline_theme='one'
"let g:Powerline_symbols='fancy'
"let g:airline_powerline_fonts=1
"let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])

" vim-javascript
let g:javascript_plugin_jsdoc = 1

" nerdcommenter
let g:NERDSpaceDelims = 1

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

" vim-vue
" Author's recommendation to fix bug where highlighting stops working randomly
autocmd FileType vue syntax sync fromstart
let g:vue_disable_pre_processors=1

" Sync cursor color to (vim-one, not bubblegum) Airline color
highlight Cursor guibg=#99C27C
" hi Visual guifg=#000000 guibg=#C57BDB
autocmd InsertEnter * highlight  Cursor guibg=#65B0ED
autocmd InsertEnter * highlight  CursorLine guibg=#2F3244
autocmd InsertLeave * highlight  Cursor guibg=#99C27C 
autocmd InsertLeave * highlight  CursorLine guibg=#2C323C


" CTRL-A to copy fzf-vim :Ag to quickfix list
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })
