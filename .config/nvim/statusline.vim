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
  \ 'R':  'yellow',
  \ 'v':  'magenta',
  \ 'V':  'magenta',
  \ '': 'magenta',
  \ 'c':  'cyan',
  \ 't':  'green'
\ }

let s:hl_groups = {
  \ 'bubble':          'MyStatusLineBubble',
  \ 'bubble_bright':   'MyStatusLineBubbleBright',
  \ 'disabled':        'MyStatusLineDisabled',
  \ 'disabled_bright': 'MyStatusLineDisabledBright',
  \ 'badge':           'MyStatusLineBadge',
  \ 'file':            'MyStatusLineFile',
  \ 'lock_inactive':   'MyStatusLineLockInactive',
  \ 'lock_active':     'MyStatusLineLockActive',
  \ 'modified_clean':  'MyStatusLineModifiedClean',
  \ 'modified_dirty':  'MyStatusLineModifiedDirty',
  \ 'branch':          'MyStatusLineBranch',
  \ 'linecol':         'MyStatusLineLineCol',
  \ 'progress':        'MyStatusLineProgress'
\ }

let s:hl_group_active_pairs = {
  \ 'badge':    [s:hl_groups.disabled_bright, s:hl_groups.badge],
  \ 'file':     [s:hl_groups.disabled,        s:hl_groups.file],
  \ 'branch':   [s:hl_groups.disabled,        s:hl_groups.branch],
  \ 'linecol':  [s:hl_groups.disabled,        s:hl_groups.linecol],
  \ 'progress': [s:hl_groups.disabled,        s:hl_groups.progress]
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
call s:Highlight(s:hl_groups.disabled_bright, s:colors.bright_black, s:colors.bright_black)

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
" 'hi link' is slower than 'hi' to just re-color a given group
"
" To profile:
" - :profile start profile.log
" - :profile func *
" - :profile file *
" - <do slow operation>
" - :profile pause
" - :noautocmd qall!
function! HighlightMode(mode) abort
  if get(w:render_cache, 'mode', '') == a:mode
    return ''
  endif
  let w:render_cache.mode = a:mode

  let l:fg = s:colors[s:mode_colors[a:mode]]
  call s:Highlight(s:hl_groups.badge, l:fg, s:colors.bright_black)
  call s:Highlight(s:hl_groups.file, l:fg, s:colors.black)
  return ''
endfunction

function! RenderLockInactive(window_active, modifiable, readonly) abort
  " Right padding in case the 'modified' circle is also shown
  let l:icon = s:icon_lock . (a:modifiable ? ' ' : '')
  return (!a:window_active && (!a:modifiable || a:readonly)) ? l:icon : ''
endfunction

function! RenderLockActive(window_active, modifiable, readonly) abort
  let l:icon = s:icon_lock . (a:modifiable ? ' ' : '')
  return (a:window_active && (!a:modifiable || a:readonly)) ? l:icon : ''
endfunction

function! RenderModifiedClean(modifiable, modified) abort
  return (a:modifiable && !a:modified) ? s:icon_circle : ''
endfunction

function! RenderModifiedDirty(modifiable, modified) abort
  return (a:modifiable && a:modified) ? s:icon_circle : ''
endfunction

function! RenderBranch() abort
  let l:branch = get(w:render_cache, 'branch', 'cache_miss')
  if l:branch == 'cache_miss'
    let l:branch = FugitiveHead()
    let w:render_cache.branch = l:branch
  endif
  if l:branch == ''
    return '-'
  else
    return l:branch
  endif
endfunction

augroup vimrc
  autocmd WinEnter,BufEnter * call s:OnActiveWindowChange(1)
  autocmd WinLeave          * call s:OnActiveWindowChange(0)

  " When launching Vim with multiple windows via '-O', render the
  " statusline of all inactive windows once.
  autocmd VimEnter * ++once call s:RenderInactiveWindowStatusLines()
augroup END

function! s:InitState(window_id) abort
  call setwinvar(a:window_id, 'render_cache', {
    \ 'mode': '',
    \ 'branch': ''
  \ })
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

function! s:RenderStatusLine(window_id, window_active) abort
  let l:line = '%{HighlightMode(mode())}'

  " Left side
  let l:line .= '%#' . s:hl_groups.bubble_bright . '#' . s:icon_circle_left
  let l:line .= '%#' . s:hl_group_active_pairs.badge[a:window_active] . '#' . s:icon_star . ' '
  let l:line .= '%#' . s:hl_group_active_pairs.file[a:window_active] . '# %f'
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_right
  let l:line .= ' '
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_left
  let l:line .= '%#MyStatusLineLockInactive#%{RenderLockInactive(''' . a:window_active . ''',&modifiable,&readonly)}'
  let l:line .= '%#MyStatusLineLockActive#%{RenderLockActive(''' . a:window_active . ''',&modifiable,&readonly)}'
  let l:line .= '%#MyStatusLineModifiedClean#%{RenderModifiedClean(&modifiable,&modified)}'
  let l:line .= '%#MyStatusLineModifiedDirty#%{RenderModifiedDirty(&modifiable,&modified)}'
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_right

  " Spacer between left and right items
  let l:line .= '%='

  " Right side
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_left
  let l:line .= '%#' . s:hl_group_active_pairs.branch[a:window_active] . '#%{RenderBranch()}'
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_right
  let l:line .= ' '
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_left
  let l:line .= '%#' . s:hl_group_active_pairs.linecol[a:window_active] . '#%l:%c'
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_right
  let l:line .= ' '
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_left
  let l:line .= '%#' . s:hl_group_active_pairs.progress[a:window_active] . '#%P/%L'
  let l:line .= '%#' . s:hl_groups.bubble . '#' . s:icon_circle_right

  if getwinvar(a:window_id, '&statusline') != l:line
    call setwinvar(a:window_id, '&statusline', l:line)
  endif
endfunction
