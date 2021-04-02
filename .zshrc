# Flags {{{
# https://www.reddit.com/r/zsh/comments/877oty/how_to_improve_shell_loading_times/
PERF=false
# }}}

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
setopt CORRECT
# }}}

# PATH Environment {{{
export PATH=$PATH:/Applications/MacVim.app/Contents/bin
export VISUAL=nvim
# }}}

# ALIASES {{{
alias ls='ls -GFh'
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias g='git'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias todo='vim $HOME/Documents/Dropbox/vimwiki/TODO.md'
alias grep='grep --color=auto'
RG_COMMON_OPTS="--smart-case --follow --hidden --glob \"!.git\""
alias rg="rg --pcre2 $RG_COMMON_OPTS"
# Also see: git config --get-regexp alias
# }}}

# Libraries, Tools {{{
# Google Cloud SDK
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/completion.zsh.inc'; fi

# zsh-nvm
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
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

zinit light lukechilds/zsh-nvm

zinit ice from"gh" wait"1" silent pick"zsh-history-substring-search.plugin.zsh" lucid
zinit light zsh-users/zsh-history-substring-search

# Causes noticable lag when typing.
# Also syntax highlighting should be loaded last.
# zinit light zdharma/fast-syntax-highlighting
# }}}

# CUSTOM SCRIPTS {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# Powerlevel10k auto-generated:
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

for script ($HOME/scripts/autoexec/(zsh|sh)/*.(zsh|sh)) source $script
# }}}

# TODO: Find a cleaner way to include npm completion.  Right now it's `npm completion >> ~/.zshrc`.

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      npm completion -- "${words[@]}" \
      2>/dev/null)) || return $?
          IFS="$si"
          if type __ltrim_colon_completions &>/dev/null; then
            __ltrim_colon_completions "${words[cword]}"
          fi
        }
      complete -o default -F _npm_completion npm
    elif type compdef &>/dev/null; then
      _npm_completion() {
        local si=$IFS
        compadd -- $(COMP_CWORD=$((CURRENT-1)) \
          COMP_LINE=$BUFFER \
          COMP_POINT=0 \
          npm completion -- "${words[@]}" \
          2>/dev/null)
                  IFS=$si
                }
              compdef _npm_completion npm
            elif type compctl &>/dev/null; then
              _npm_completion () {
                local cword line point words si
                read -Ac words
                read -cn cword
                let cword-=1
                read -l line
                read -ln point
                si="$IFS"
                IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                  COMP_LINE="$line" \
                  COMP_POINT="$point" \
                  npm completion -- "${words[@]}" \
                  2>/dev/null)) || return $?
                                  IFS="$si"
                                }
                              compctl -K _npm_completion npm
fi
###-end-npm-completion-###

# iTerm2: Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

if [ $PERF = true ]; then
  zprof
fi
