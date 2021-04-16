# Based on https://github.com/junegunn/dotfiles/blob/master/bashrc
# Also see: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
#
# Hidden binding to scroll preview window: Shift+Up and Shift+Down -or- Ctrl+Up and Ctrl+Down.
# https://github.com/junegunn/fzf recommends NOT to add --preview option here. For manual preview: fzf --preview 'bat {}'
#
# Colors are a mix of terminal and elenapan's Ephemeral theme, except #CCCCCC, which is terminal White darkened by 10%.
# We don't use 0-15 here because that maps to 256 colors on Vim due to termguicolors, not the terminal colors.
export FZF_DEFAULT_OPTS='
  --multi
  --layout=reverse
  --info=inline
  --bind ctrl-a:toggle-all
  --bind ctrl-h:toggle-preview
  --color prompt:#92B6F4,info:#92B6F4,header:#BD99FF
  --color pointer:#F48FB1,marker:#EE4F84
  --color fg:#CCCCCC,bg:#323F4E
  --color fg+:#F8F8F2,bg+:#323F4E
  --color hl:#F48FB1,hl+:#F48FB1
  --color border:#323F4E
'

export FZF_CTRL_R_OPTS="
  --header 'CTRL-Y: Copy to clipboard'
  --color header:italic
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --preview 'echo {}'
  --preview-window down:3:hidden:wrap
"

export FZF_CTRL_T_OPTS="
  --preview 'bat {}'
  --preview-window hidden
"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# NOTE: There is a performance issue because rg and fd use depth-first-search.
# - https://github.com/BurntSushi/ripgrep/pull/1554
# - https://github.com/sharkdp/fd/issues/599
# - https://github.com/junegunn/fzf/issues/2059
#
# Potential improvements coming for fd
# - https://github.com/sharkdp/fd/issues/734
#
# For ALT_C, consider: https://github.com/junegunn/blsd
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'
