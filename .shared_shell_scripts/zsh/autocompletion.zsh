# https://github.com/xero/dotfiles/tree/master/zsh/.zsh
autoload -Uz compinit
compinit -u
source $HOME/.shared_shell_scripts/zsh/completion/npm

# Highlight selection background as you tab through autocomplete options
zstyle ':completion:*' menu select

# Use LS_COLORS (defined in .zshrc) to match ls colors.
# Highlight prefix/text of autocomplete options that are already typed.
# ma is a special attribute for zsh's menu selection color
# https://gist.github.com/thomd/7667642
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}:ma=100")';
