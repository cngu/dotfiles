#
# fasd
#
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

alias c='zz'
alias j='zz'
#alias v='a -ie vim'
#alias mvim='a -ie mvim'
alias o='d -ie open'

