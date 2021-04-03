export FZF_DEFAULT_COMMAND="rg --files"

# Hidden binding to scroll preview window: Shift+Up and Shift+Down
# https://github.com/junegunn/fzf recommends NOT to add --preview option here. For manual preview: fzf --preview 'bat {}'
export FZF_DEFAULT_OPTS='--layout=reverse --info=inline --keep-right --bind ctrl-h:toggle-preview'
