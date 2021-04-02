# --files: List files that would be searched but do not search
# --follow: Follow symlinks
# --hidden: Search hidden files and folders
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND="rg --files $RG_COMMON_OPTS"

# Hidden binding to scroll preview window: Shift+Up and Shift+Down
# https://github.com/junegunn/fzf recommends NOT to add --preview option here. For manual preview: fzf --preview 'bat {}'
export FZF_DEFAULT_OPTS='--layout=reverse --info=inline --keep-right --bind ctrl-h:toggle-preview'
