" Based on https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
" Uses 16-color from terminals. Requires that termguicolors is NOT set.

set noshowmode

" ~~~~ Statusline configuration ~~~~
" ':help statusline' is your friend!
function! RedrawModeColors(mode)
  " Normal mode
  if a:mode == 'n'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=4 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=4
  " Insert mode
  elseif a:mode == 'i'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=1 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=1
  " Replace mode
  elseif a:mode == 'R'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=3 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=3
  " Visual mode
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=5 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=5
  " Command mode
  elseif a:mode == 'c'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=6 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=6
  " Terminal mode
  elseif a:mode == 't'
    hi MyStatuslineAccent ctermfg=8 cterm=NONE ctermbg=NONE
    hi MyStatuslineFilename ctermfg=1 cterm=none ctermbg=0
    hi MyStatuslineAccentBody ctermbg=8 cterm=NONE ctermfg=1
  endif
  " Return empty string so as not to display anything in the statusline
  return ''
endfunction

function! SetModifiedSymbol(modified)
    if a:modified == 1
        hi MyStatuslineModifiedBody ctermbg=0 cterm=bold ctermfg=1
    else
        hi MyStatuslineModifiedBody ctermbg=0 cterm=bold ctermfg=8
    endif
    return '●'
endfunction

function! SetFiletype(filetype)
  if a:filetype == ''
      return '-'
  else
      return a:filetype
  endif
endfunction


" Statusbar items
" ====================================================================

" This will not be displayed, but the function RedrawModeColors will be
" called every time the mode changes, thus updating the colors used for the
" components.
set statusline=%{RedrawModeColors(mode())}
" Left side items
" =======================
set statusline+=%#MyStatuslineAccent#
set statusline+=%#MyStatuslineAccentBody#
" Filename
set statusline+=\ %#MyStatuslineFilename#\ %f
set statusline+=%#MyStatuslineSeparator#
" Modified status
set statusline+=\ %#MyStatuslineModified#
set statusline+=%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}
set statusline+=%#MyStatuslineModified#
" Right side items
" =======================
set statusline+=%=
" Line and Column
set statusline+=%#MyStatuslineLineCol#
set statusline+=%#MyStatuslineLineColBody#%l
set statusline+=:%#MyStatuslineLineColBody#%c
set statusline+=%#MyStatuslineLineCol#
" Current scroll percentage and total lines of the file
set statusline+=\ %#MyStatuslinePercentage#
set statusline+=%#MyStatuslinePercentageBody#%P
set statusline+=\/\%#MyStatuslinePercentageBody#%L
set statusline+=%#MyStatuslinePercentage#
" Filetype
set statusline+=\ %#MyStatuslineFiletype#
set statusline+=%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}
set statusline+=%#MyStatuslineFiletype#

" Setup the colors
hi StatusLine          ctermfg=5     ctermbg=NONE     cterm=NONE
hi StatusLineNC        ctermfg=8     ctermbg=NONE     cterm=bold

hi MyStatuslineSeparator ctermfg=0 cterm=NONE ctermbg=NONE

hi MyStatuslineModified ctermfg=0 cterm=NONE ctermbg=NONE

hi MyStatuslineFiletype ctermbg=NONE cterm=NONE ctermfg=0
hi MyStatuslineFiletypeBody ctermfg=5 cterm=italic ctermbg=0

hi MyStatuslinePercentage ctermfg=0 cterm=NONE ctermbg=NONE
hi MyStatuslinePercentageBody ctermbg=0 cterm=none ctermfg=6

hi MyStatuslineLineCol ctermfg=0 cterm=NONE ctermbg=NONE
hi MyStatuslineLineColBody ctermbg=0 cterm=none ctermfg=2
