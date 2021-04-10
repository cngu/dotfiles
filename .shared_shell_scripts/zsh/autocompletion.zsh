# https://github.com/xero/dotfiles/tree/master/zsh/.zsh
autoload -Uz compinit
compinit -u
source $HOME/.shared_shell_scripts/zsh/completion/npm

# Highlight selection background as you tab through autocomplete options
zstyle ':completion:*' menu select

# Highlight prefix/text of autocomplete options that are already typed
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")';
