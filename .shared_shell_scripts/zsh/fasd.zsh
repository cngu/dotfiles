#
# fasd
#
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)" >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

alias c='zz'
alias j='zz'
#alias v='a -ie vim'
#alias mvim='a -ie mvim'
alias o='d -ie open'

