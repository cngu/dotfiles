# --files: List files that would be searched but do not search
# --follow: Follow symlinks
# --hidden: Search hidden files and folders
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --glob "!.git"'

export FZF_DEFAULT_OPTS='--layout=reverse --info=inline --bind ctrl-h:toggle-preview'
