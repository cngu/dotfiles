# https://www.reddit.com/r/zsh/comments/877oty/how_to_improve_shell_loading_times/
PERF=false

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
echo ${(pl.$LINES..\n.)}
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ $PERF = true ]; then
 zmodload zsh/zprof
fi

# Options {{{
bindkey -e

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
#setopt NO_CASE_GLOB
setopt GLOBDOTS
setopt CORRECT
# }}}

# Environment {{{
export PATH="$PATH:$HOME/bin"
export PATH=$PATH:/Applications/MacVim.app/Contents/bin

# n (Node version manager)
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# Used by git commit
export VISUAL=nvim

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Mirrors default LSCOLORS.
# LS_COLORS is used by zsh autocompletion e.g ls -al <tab>
# https://gist.github.com/thomd/7667642
# https://geoff.greer.fm/lscolors/
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
# }}}

# Alias {{{
alias ls='ls -GFh'
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias g='git'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias todo='nvim $HOME/Documents/Dropbox/vimwiki/TODO.md'
alias grep='grep --color=auto'
# Also see: git config --get-regexp alias
# }}}

# Terminal Tab Title {{{
if [ $ITERM_SESSION_ID ]; then
  autoload -Uz add-zsh-hook

  DISABLE_AUTO_TITLE="true"
  tab_title() {
    local path="${PWD/$HOME/~}"
    echo -ne "\e]1;$path\a"
  }
  add-zsh-hook precmd tab_title
fi
# }}}

# Package Manager (zinit) {{{
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
  command mkdir -p $HOME/.zinit
  command git clone https://github.com/zdharma/zinit $HOME/.zinit/bin && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
    print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# Causes noticable lag when typing.
# Also syntax highlighting should be loaded last.
# zinit light zdharma/fast-syntax-highlighting
# }}}

for script ($HOME/.shared_shell_scripts/(zsh|sh)/*.(zsh|sh)) source $script

# AUTOGENERATED Powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# AUTOGENERATED iTerm2: Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# AUTOGENERATED fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ $PERF = true ]; then
  zprof
fi
