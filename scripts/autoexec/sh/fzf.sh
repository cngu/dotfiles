export FZF_DEFAULT_COMMAND="rg --files"

# Hidden binding to scroll preview window: Shift+Up and Shift+Down
# https://github.com/junegunn/fzf recommends NOT to add --preview option here. For manual preview: fzf --preview 'bat {}'
#
# Colors are a mix of terminal and elenapan's Ephemeral theme, except #CCCCCC, which is terminal White darkened by 10%.
# We don't use 0-15 here because that maps to 256 colors on Vim due to termguicolors, not the terminal colors.
export FZF_DEFAULT_OPTS='
  --multi
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
