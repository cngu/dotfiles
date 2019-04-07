# LIBRARIES, BINARIES, TOOLS, etc. {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#. "$(brew --prefix nvm)/nvm.sh"

export JAVA_HOME=$(/usr/libexec/java_home)
export IDEA_JDK=$JAVA_HOME

export PATH=$PATH:/Users/cnguyen/libs/gradle-2.14.1/bin
export PATH=$PATH:/Applications/MacVim.app/Contents/bin
# }}}

# STYLING AND THEMING {{{
export TERM="xterm-color" 
# }}}

# ALIASES {{{
alias ls="ls -Gh"
alias grep="grep --color=always"
# alias rg="rg --smart-case"
alias rg="rg -g '!.git' --hidden"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# }}}

# CUSTOM SCRIPTS {{{
for script in $HOME/scripts/shell/sh/*.sh; do
  source $script
done
# }}}

# Must be after scripts above for exit status to work
source ~/scripts/shell/sh/bash-powerline/bash-powerline.sh

source /usr/local/etc/bash_completion.d/git-completion.bash

# USEFUL FUNCTIONS {{{
upto()
{
    if [ -z "$1" ]; then
        return
    fi
    local upto=$1
    cd "${PWD/\/$upto\/*//$upto}"
}

_upto()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    local d=${PWD//\//\ }
    COMPREPLY=( $( compgen -W "$d" -- "$cur" ) )
}
complete -F _upto upto

jd()
{
    if [ -z "$1" ]; then
        echo "Usage: jd [directory]";
        return 1
    else
        cd **"/$1"
    fi
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/path.bash.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/completion.bash.inc'; fi
# }}}
