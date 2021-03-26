# LIBRARIES, BINARIES, TOOLS, etc. {{{
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#. "$(brew --prefix nvm)/nvm.sh"

export JAVA_HOME=$(/usr/libexec/java_home)
export IDEA_JDK=$JAVA_HOME

export PATH=$PATH:/Users/cnguyen/libs/mongodb/bin
export PATH=$PATH:/Applications/MacVim.app/Contents/bin
# }}}

# STYLING AND THEMING {{{
export TERM="xterm-color" 
if [ $ITERM_SESSION_ID ]; then
  # If PC contains anything, add semicolon and space
  if [ ! -z "$PROMPT_COMMAND" ]; then
    PROMPT_COMMAND="$PROMPT_COMMAND; "
  fi

  # Add custom PC
  ITERM_TITLE='echo -ne "\033];${PWD/#$HOME/~}\007"; ':"$PROMPT_COMMAND";
  PROMPT_COMMAND=$PROMPT_COMMAND"$ITERM_TITLE"
fi
# }}}

# ALIASES {{{
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias todo='vim $HOME/Documents/GoogleDrive/vimwiki/TODO.md'
alias ls='ls -Gh'
alias rg='rg --pcre2 --smart-case --hidden --glob "!.git"'
# Also see: git config --get-regexp alias
# }}}

# CUSTOM SCRIPTS {{{
for script in $HOME/scripts/autoexec/(sh|bash)/*.sh; do
  source $script
done
# }}}

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
