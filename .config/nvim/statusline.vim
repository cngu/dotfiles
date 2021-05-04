" Statusline based on elenapan's statusline.vim:
" https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
"
" Colors taken from elenapan's 'Ephemeral' theme:
" https://github.com/elenapan/dotfiles/blob/master/.xfiles/ephemeral
"
" Requires 16-color or true color terminal.

set noshowmode

let s:icon_lock = ''
let s:icon_circle = ''
let s:icon_circle_left = ''
let s:icon_circle_right = ''
let s:icon_star = ''

let s:colors = {
  \ 'transparent':  { 'cterm': 'NONE', 'gui': 'NONE' },
  \ 'black':        { 'cterm': '0', 'gui': '#33404F' },
  \ 'red':          { 'cterm': '1', 'gui': '#F48FB1' },
  \ 'green':        { 'cterm': '2', 'gui': '#A1EFD3' },
  \ 'yellow':       { 'cterm': '3', 'gui': '#F1FA8C' },
  \ 'blue':         { 'cterm': '4', 'gui': '#92B6F4' },
  \ 'magenta':      { 'cterm': '5', 'gui': '#BD99FF' },
  \ 'cyan':         { 'cterm': '6', 'gui': '#87DFEB' },
  \ 'bright_black': { 'cterm': '8', 'gui': '#5C7087' }
\ }

let s:mode_colors = {
  \ 'n':  'blue',
  \ 'i':  'red',
  \ 'r':  'yellow',
  \ 'R':  'yellow',
  \ 'v':  'magenta',
  \ 'V':  'magenta',
  \ '': 'magenta',
  \ 'c':  'cyan',
  \ 't':  'green'
\ }

let s:hl_groups = {
  \ 'bubble':         'MyStatusLineBubble',
  \ 'bubble_bright':  'MyStatusLineBubbleBright',
  \ 'disabled':       'MyStatusLineDisabled',
  \ 'badge':          'MyStatusLineBadge',
  \ 'file':           'MyStatusLineFile',
  \ 'lock_active':    'MyStatusLineLockActive',
  \ 'lock_inactive':  'MyStatusLineLockInactive',
  \ 'modified_clean': 'MyStatusLineModifiedClean',
  \ 'modified_dirty': 'MyStatusLineModifiedDirty',
  \ 'branch':         'MyStatusLineBranch',
  \ 'linecol':        'MyStatusLineLineCol',
  \ 'progress':       'MyStatusLineProgress',
  \ 'tab':            'MyTab'
\ }

" Components without 'highlight' will inherit previous component's highlight
let s:components = {
  \ 'separator': {
    \ 'text': ' '
  \ },
  \ 'bubble_left': {
    \ 'text': s:icon_circle_left,
    \ 'highlight': s:hl_groups.bubble
  \ },
  \ 'bubble_left_bright': {
    \ 'text': s:icon_circle_left,
    \ 'highlight': s:hl_groups.bubble_bright
  \ },
  \ 'bubble_middle': {
    \ 'text': ' ',
    \ 'highlight': s:hl_groups.disabled
  \ },
  \ 'bubble_right': {
    \ 'text': s:icon_circle_right,
    \ 'highlight': s:hl_groups.bubble
  \ },
  \ 'badge': {
    \ 'text': s:icon_star . ' ' ,
    \ 'highlight': s:hl_groups.badge
  \ },
  \ 'file_active': {
    \ 'text': ' %f',
    \ 'highlight': s:hl_groups.file
  \ },
  \ 'file_inactive': {
    \ 'text': ' %f',
    \ 'highlight': s:hl_groups.disabled
  \ },
  \ 'lock_active': {
    \ 'render': 'RenderLockActive',
    \ 'highlight': s:hl_groups.lock_active
  \ },
  \ 'lock_inactive': {
    \ 'render': 'RenderLockInactive',
    \ 'highlight': s:hl_groups.lock_inactive
  \ },
  \ 'modified_clean': {
    \ 'render': 'RenderModifiedClean',
    \ 'highlight': s:hl_groups.modified_clean
  \ },
  \ 'modified_dirty': {
    \ 'render': 'RenderModifiedDirty',
    \ 'highlight': s:hl_groups.modified_dirty
  \ },
  \ 'branch_active': {
    \ 'render': 'RenderBranch',
    \ 'highlight': s:hl_groups.branch
  \ },
  \ 'branch_inactive': {
    \ 'render': 'RenderBranch',
    \ 'highlight': s:hl_groups.disabled
  \ },
  \ 'linecol_active': {
    \ 'text': '%l:%c',
    \ 'highlight': s:hl_groups.linecol
  \ },
  \ 'linecol_inactive': {
    \ 'text': '%l:%c',
    \ 'highlight': s:hl_groups.disabled
  \ },
  \ 'progress_active': {
    \ 'text': '%P/%L',
    \ 'highlight': s:hl_groups.progress
  \ },
  \ 'progress_inactive': {
    \ 'text': '%P/%L',
    \ 'highlight': s:hl_groups.disabled
  \ }
\ }

let s:line_components = {
  \ 'active': {
    \ 'left': [
      \ s:components.bubble_left_bright,
      \ s:components.badge,
      \ s:components.file_active,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.lock_active,
      \ s:components.lock_inactive,
      \ s:components.modified_clean,
      \ s:components.modified_dirty,
      \ s:components.bubble_right
    \ ],
    \ 'right': [
      \ s:components.bubble_left,
      \ s:components.branch_active,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.linecol_active,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.progress_active,
      \ s:components.bubble_right
    \ ]
  \ },
  \ 'inactive': {
    \ 'left': [
      \ s:components.bubble_left,
      \ s:components.bubble_middle,
      \ s:components.bubble_middle,
      \ s:components.file_inactive,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.lock_active,
      \ s:components.lock_inactive,
      \ s:components.modified_clean,
      \ s:components.modified_dirty,
      \ s:components.bubble_right
    \ ],
    \ 'right': [
      \ s:components.bubble_left,
      \ s:components.branch_inactive,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.linecol_inactive,
      \ s:components.bubble_right,
      \ s:components.separator,
      \ s:components.bubble_left,
      \ s:components.progress_inactive,
      \ s:components.bubble_right
    \ ]
  \ }
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

call s:Highlight(s:hl_groups.bubble, s:colors.black)
call s:Highlight(s:hl_groups.bubble_bright, s:colors.bright_black)
call s:Highlight(s:hl_groups.disabled, s:colors.bright_black, s:colors.black)
call s:Highlight(s:hl_groups.lock_inactive, s:colors.bright_black, s:colors.black)
call s:Highlight(s:hl_groups.lock_active, s:colors.red, s:colors.black)
call s:Highlight(s:hl_groups.modified_clean, s:colors.bright_black, s:colors.black)
call s:Highlight(s:hl_groups.modified_dirty, s:colors.red, s:colors.black)
call s:Highlight(s:hl_groups.branch, s:colors.magenta, s:colors.black)
call s:Highlight(s:hl_groups.linecol, s:colors.green, s:colors.black)
call s:Highlight(s:hl_groups.progress, s:colors.cyan, s:colors.black)

" Highlight notes:
"
" Dynamic highlight groups are not possible. They must be statically declared.
"
" It's also important to understand that highlight groups are global.
" If you modify a highlight group and you notice that it's not updating an
" inactive window's statusline, that's simply because Vim is not re-rendering
" the inactive statusline. If you then try an approach where you rely on Vim
" to evaluate %{} expressions to highlight the statusline last on the active
" window, and stop evaluating on inactive windows, then the statuslines would
" render correctly on all windows, but with massive performance issues if you
" do any operation that would cause the statusline on inactive windows to
" re-render. The windows try and modify the highlight, and trigger
" re-rendering on other windows, continuously overwriting each other.
" An easy test is to try and mouse-scroll on an inactive window.
"
" Highlight groups cannot be set locally either:
" - https://github.com/vim/vim/issues/3576
" - https://stackoverflow.com/questions/49301534/vim-highlight-setting-local
"
" Therefore, we take the approach explained here:
" - https://gist.github.com/romainl/58245df413641497a02ffc06fd1f4747
" - We also use a different statusline string for active vs inactive windows.
"
" However, this can result in quite a lengthy statusline string.
" When a highlight group is guaranteed to only be used in a single window's
" statusline (likely the active window), then we can reduce the length:
" instead of defining every combination of highlight group states, define only
" one highlight group and highlight it to another predefined group, based on
" your state. In our case, we do this for statusline components based on mode.
"
" Note on %{} expressions:
" They are evaluated very frequently as the statusline re-renders.
" For performance, ensure embedded functions return early as possible.
" They are usually used to return dynamic content on each render.
" However, they can also be used as a hook to execute arbitrary code, for
" example highlight commands, on every render. HighlightMode is an example of
" this that re-links highlight groups that are dependent on the current mode.
" Alternatively, we could re-set the statusline string when the mode changes,
" but that is finicky to handle every case e.g. 'VisualEnter' does not exist.
"
" Note on performance:
" - 'hi link' is slower than 'hi' to just re-color a given group.
" - RenderStatusLine() is only called from the autocmd, so focus more on
"   evaluated %{} expressions.
" - Remove any evaluated expressions and function calls in RenderStatusLine().
" - Does Vim do string interning? Extract common strings into vars and reuse.
function! HighlightMode(mode) abort
  if get(w:render_cache, 'mode', '') ==# a:mode
    return ''
  endif
  let w:render_cache.mode = a:mode

  let l:fg = s:colors[s:mode_colors[a:mode]]
  call s:Highlight(s:hl_groups.badge, l:fg, s:colors.bright_black)
  call s:Highlight(s:hl_groups.file, l:fg, s:colors.black)
  return ''
endfunction

function! RenderLockInactive(window_active) abort
  " Right padding in case the 'modified' circle is also shown
  let l:icon = s:icon_lock . (&modifiable ? ' ' : '')
  return (!a:window_active && (!&modifiable || &readonly)) ? l:icon : ''
endfunction

function! RenderLockActive(window_active) abort
  let l:icon = s:icon_lock . (&modifiable ? ' ' : '')
  return (a:window_active && (!&modifiable || &readonly)) ? l:icon : ''
endfunction

function! RenderModifiedClean(...) abort
  return (&modifiable && !&modified) ? s:icon_circle : ''
endfunction

function! RenderModifiedDirty(...) abort
  return (&modifiable && &modified) ? s:icon_circle : ''
endfunction

function! RenderBranch(...) abort
  let l:branch = get(w:render_cache, 'branch', 'cache_miss')
  if l:branch ==# 'cache_miss'
    let l:branch = FugitiveHead()
    let w:render_cache.branch = l:branch
  endif
  if l:branch ==# ''
    return '-'
  else
    return l:branch
  endif
endfunction

function! s:RenderComponent(component, window_active) abort
  let l:result = ''
  if has_key(a:component, 'highlight')
    let l:result .= '%#' . a:component.highlight . '#'
  endif
  if has_key(a:component, 'render')
    let l:result .= '%{' . a:component.render . '(''' . a:window_active . ''')}'
  else
    let l:result .= a:component.text
  endif
  return l:result
endfunction

function! s:RenderStatusLine(window_id, window_active) abort
  if a:window_active
    let l:components = s:line_components.active
  else
    let l:components = s:line_components.inactive
  endif

  let l:line = '%{HighlightMode(mode())}'
  for component in l:components.left
    let l:line .= s:RenderComponent(component, a:window_active)
  endfor
  let l:line .= '%='
  for component in l:components.right
    let l:line .= s:RenderComponent(component, a:window_active)
  endfor

  if getwinvar(a:window_id, '&statusline') != l:line
    call setwinvar(a:window_id, '&statusline', l:line)
  endif
endfunction

function! s:InitState(window_id) abort
  call setwinvar(a:window_id, 'render_cache', {})
endfunction

function! s:OnActiveWindowChange(window_active) abort
  let l:window_id = winnr()
  call s:InitState(l:window_id)
  call s:RenderStatusLine(l:window_id, a:window_active)
endfunction

function! s:RenderInactiveWindowStatusLines() abort
  let l:window_id = winnr()
  for n in range(1, winnr('$'))
    if l:window_id != n
      call s:InitState(n)
      call s:RenderStatusLine(n, 0)
    endif
  endfor
endfunction

"
" Statusline
"
augroup vimrc
  autocmd WinEnter,BufEnter * call s:OnActiveWindowChange(1)
  autocmd WinLeave          * call s:OnActiveWindowChange(0)

  " When launching Vim with multiple windows via '-O', render the
  " statusline of all inactive windows once.
  autocmd VimEnter * ++once call s:RenderInactiveWindowStatusLines()
augroup END

"
" Tabline - mostly taken from :h tabline
"
function RenderTabLabel(tabnr) abort
  let l:label = a:tabnr . ' '

  " Tabs are numbered 1 to T.
  " Every tab has windows 1 to N.
  " Each window can show buffer B, where B is unique across windows and tabs.
  let l:buflist = tabpagebuflist(a:tabnr)
  let l:winnr = tabpagewinnr(a:tabnr)
  let l:bufnr = l:buflist[l:winnr - 1]
  let l:bufname = bufname(l:bufnr)
  let l:filename = fnamemodify(l:bufname, ':t')
  let l:filetype = getbufvar(l:bufnr, '&filetype')

  " Found a weird buffer that doesn't have a &filetype?  Try &buftype.
  if l:filetype ==# 'qf'
    let l:label .= '[Quickfix]'
  elseif l:filetype ==# 'fzf'
    let l:label .= '[fzf]'
  elseif l:filetype ==# 'help'
    let l:label .= '[Help]'
  else
    let l:label = empty(l:filename) ? '[No Name]' : l:filename
  endif

  return l:label
endfunction

function s:HighlightTab(tabnr) abort
  let l:buflist = tabpagebuflist(a:tabnr)
  let l:modified = 0
  for i in l:buflist
    if getbufvar(i, '&modified')
      let l:modified = 1
      break
    endif
  endfor

  if l:modified && a:tabnr ==# tabpagenr()
    call s:Highlight(s:hl_groups.tab . a:tabnr, s:colors.magenta)
  elseif l:modified
    call s:Highlight(s:hl_groups.tab . a:tabnr, s:colors.red)
  elseif a:tabnr ==# tabpagenr()
    call s:Highlight(s:hl_groups.tab . a:tabnr, s:colors.blue)
  else
    call s:Highlight(s:hl_groups.tab . a:tabnr, s:colors.bright_black)
  endif
endfunction

function! RenderTabLine() abort
  let l:line = ''

  for i in range(tabpagenr('$'))
    let l:tabnr = i + 1

    " Extra space between tabs
    if l:tabnr > 1
      let l:line .= ' '
    endif

    let l:line .= '%#' . s:hl_groups.tab . l:tabnr . '#'
    let l:line .= '%' . l:tabnr . 'T'
    let l:line .= '%{RenderTabLabel(' . l:tabnr . ')}%T '

    call s:HighlightTab(l:tabnr)
  endfor

  " After the last tab, fill with TabLineFill
  let l:line .= '%#TabLineFill#'

  return l:line
endfunction

set tabline=%!RenderTabLine()
