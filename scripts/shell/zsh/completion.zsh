
#
# zsh-completions
#
# Highlight selection background as you tab through autocomplete options
zstyle ':completion:*' menu select

# Highlight prefix/text of autocomplete options that are already typed
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';

# Allow shift+tab backwards through autocomplete options
bindkey '^[[Z' reverse-menu-complete

#
# zsh-history-substring-search
#
# Allows typing part of a previous command and pressing up or down arrows to filter history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
