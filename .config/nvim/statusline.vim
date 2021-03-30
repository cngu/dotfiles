" Statusline based on elenapan's statusline.vim:
" https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
"
" Colors taken from elenapan's 'Ephemeral' theme:
" https://github.com/elenapan/dotfiles/blob/master/.xfiles/ephemeral
"
" Requires 16-color or true color terminal.

set noshowmode

let s:colors = {
  \ 'transparent':  { 'cterm': 'NONE', 'gui': 'NONE' },
  \ 'black':        { 'cterm': '0', 'gui': '#3D4C5F' },
  \ 'red':          { 'cterm': '1', 'gui': '#F48FB1' },
  \ 'green':        { 'cterm': '2', 'gui': '#A1EFD3' },
  \ 'yellow':       { 'cterm': '3', 'gui': '#F1FA8C' },
  \ 'blue':         { 'cterm': '4', 'gui': '#92B6F4' },
  \ 'magenta':      { 'cterm': '5', 'gui': '#BD99FF' },
  \ 'cyan':         { 'cterm': '6', 'gui': '#87DFEB' },
  \ 'bright_black': { 'cterm': '8', 'gui': '#56687E' }
\ }

let s:modes = {
  \ 'n': 'Normal',
  \ 'i': 'Insert',
  \ 'R': 'Replace',
  \ 'v': 'Visual',
  \ 'V': 'Visual',
  \ '': 'Visual',
  \ 'c': 'Command',
  \ 't': 'Terminal'
\ }

function! s:Highlight(group, fg, ...) abort
  let l:bg = get(a:, 1, s:colors.transparent)
  let l:attr = get(a:, 2, '')

  exec printf('hi %s ctermfg=%s ctermbg=%s guifg=%s guibg=%s',
    \ a:group, a:fg.cterm, l:bg.cterm, a:fg.gui, l:bg.gui)

  if l:attr != ''
    exec printf('hi %s cterm=%s gui=%s', a:group, l:attr, l:attr)
  endif
endfunction

call s:Highlight('MyStatuslineDisabled', s:colors.bright_black, s:colors.black)
call s:Highlight('MyStatuslineDisabledBright', s:colors.bright_black, s:colors.bright_black)
call s:Highlight('MyStatuslineBubble', s:colors.black)
call s:Highlight('MyStatuslineBubbleBright', s:colors.bright_black)
" MyStatuslineBadge
call s:Highlight('MyStatuslineBadgeNormal', s:colors.blue, s:colors.bright_black)
call s:Highlight('MyStatuslineBadgeInsert', s:colors.red, s:colors.bright_black)
call s:Highlight('MyStatuslineBadgeReplace', s:colors.yellow, s:colors.bright_black)
call s:Highlight('MyStatuslineBadgeVisual', s:colors.magenta, s:colors.bright_black)
call s:Highlight('MyStatuslineBadgeCommand', s:colors.cyan, s:colors.bright_black)
call s:Highlight('MyStatuslineBadgeTerminal', s:colors.green, s:colors.bright_black)
" MyStatuslineFile
call s:Highlight('MyStatuslineFileNormal', s:colors.blue, s:colors.black)
call s:Highlight('MyStatuslineFileInsert', s:colors.red, s:colors.black)
call s:Highlight('MyStatuslineFileReplace', s:colors.yellow, s:colors.black)
call s:Highlight('MyStatuslineFileVisual', s:colors.magenta, s:colors.black)
call s:Highlight('MyStatuslineFileCommand', s:colors.cyan, s:colors.black)
call s:Highlight('MyStatuslineFileTerminal', s:colors.green, s:colors.black)
" MyStatuslineEditSymbol
call s:Highlight('MyStatuslineEditClean', s:colors.bright_black, s:colors.black)
call s:Highlight('MyStatuslineEditModified', s:colors.red, s:colors.black)
call s:Highlight('MyStatuslineEditReadonly', s:colors.red, s:colors.black)
" MyStatuslineBranch
call s:Highlight('MyStatuslineBranchActive', s:colors.magenta, s:colors.black)
" MyStatuslineLineCol
call s:Highlight('MyStatuslineLineColActive', s:colors.green, s:colors.black)
" MyStatuslineProgress
call s:Highlight('MyStatuslineProgressActive', s:colors.cyan, s:colors.black)

" Paint* functions re-link highlight groups based on the given state.
" This is embedded in the statusline declaration as an expression that will be
" evaluated very frequently as the statusline re-renders.
" For performance, cache data and early return as soon as possible.
" Ideally we would call this ourselves only when necessary e.g. with autocmd.
" But it is finicky to handle every case e.g. 'VisualEnter' does not exist.
" https://stackoverflow.com/questions/15561132/run-command-when-vim-enters-visual-mode
let s:cache = {
  \ 'mode': '',
  \ 'modified': -1,
  \ 'readonly': -1,
  \ 'is_active_window': -1
\ }

let w:is_active_window = 1
augroup vimrc
  autocmd WinEnter * let w:is_active_window = 1
  autocmd WinLeave * let w:is_active_window = 0
augroup END

function! s:PaintFocusState() abort
  if s:cache.is_active_window == w:is_active_window
    return
  endif
  let s:cache.is_active_window = w:is_active_window

  if w:is_active_window == 0
    hi link MyStatuslineBadge MyStatuslineDisabledBright
    hi link MyStatuslineFile MyStatuslineDisabled
    hi link MyStatuslineEditSymbol MyStatuslineDisabled
    hi link MyStatuslineBranch MyStatuslineDisabled
    hi link MyStatuslineLineCol MyStatuslineDisabled
    hi link MyStatuslineProgress MyStatuslineDisabled
    let s:cache.mode = ''
    let s:cache.modified = -1
    let s:cache.readonly = -1
  else
    hi link MyStatuslineBranch MyStatuslineBranchActive
    hi link MyStatuslineLineCol MyStatuslineLineColActive
    hi link MyStatuslineProgress MyStatuslineProgressActive
  endif
endfunction

function! s:PaintMode(mode) abort
  if w:is_active_window == 0
    return
  endif

  if s:cache.mode == a:mode
    return
  endif

  let s:cache.mode = a:mode
  exec 'hi link MyStatuslineBadge MyStatuslineBadge' . s:modes[a:mode]
  exec 'hi link MyStatuslineFile MyStatuslineFile' . s:modes[a:mode]
endfunction

function! s:PaintEditSymbol(modified, readonly) abort
  if a:readonly == 1
    if w:is_active_window == 1 && s:cache.readonly != a:readonly
      let s:cache.readonly = a:readonly
      hi link MyStatuslineEditSymbol MyStatuslineEditReadonly
    endif
    return
  else
    let s:cache.readonly = a:readonly
  endif

  if s:cache.modified != a:modified
    let s:cache.modified = a:modified
    if a:modified == 0
      hi link MyStatuslineEditSymbol MyStatuslineEditClean
    else
      hi link MyStatuslineEditSymbol MyStatuslineEditModified
    endif
  endif
endfunction

function! PaintMyStatusline(mode, modified, readonly) abort
  call s:PaintFocusState()
  call s:PaintMode(a:mode)
  call s:PaintEditSymbol(a:modified, a:readonly)
  return ''
endfunction

function! GetEditSymbol(readonly) abort
  if a:readonly == 1
    return ''
  else
    return '●'
  endif
endfunction

function! GetBranch() abort
  let l:branch = FugitiveHead()
  if l:branch == ''
    return '-'
  else
    return l:branch
  endif
endfunction

function! Debug() abort
  return '[DEBUG] winnr(' . winnr()
    \ . ') is_active_window(' . s:cache.is_active_window
    \ . ') mode(' . s:cache.mode
    \ . ') modified(' . s:cache.modified
    \ . ') readonly(' . s:cache.readonly
    \ . ')'
endfunction

" Start constructing statusline
" We don't use setlocal because it won't apply to top-level windows like :h
set statusline=%{PaintMyStatusline(mode(),&modified,&readonly)}
"set statusline+=%{Debug()}

" Left side
set statusline+=%#MyStatuslineBubbleBright#
set statusline+=%#MyStatuslineBadge#
set statusline+=%{'\ '}
set statusline+=%#MyStatuslineFile#\ %f
set statusline+=%#MyStatuslineBubble#
set statusline+=%{'\ '}
set statusline+=%#MyStatuslineBubble#
set statusline+=%#MyStatuslineEditSymbol#%{GetEditSymbol(&readonly)}
set statusline+=%#MyStatuslineBubble#

set statusline+=%=

" Right side
set statusline+=%#MyStatuslineBubble#
set statusline+=%#MyStatuslineBranch#%{GetBranch()}
set statusline+=%#MyStatuslineBubble#
set statusline+=%{'\ '}
set statusline+=%#MyStatuslineBubble#
set statusline+=%#MyStatuslineLineCol#%l:%c
set statusline+=%#MyStatuslineBubble#
set statusline+=%{'\ '}
set statusline+=%#MyStatuslineBubble#
set statusline+=%#MyStatuslineProgress#%P\/%L
set statusline+=%#MyStatuslineBubble#
