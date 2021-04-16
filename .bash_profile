# Environment {{{
export PATH="$PATH:$HOME/bin"
export PATH=$PATH:/Users/cnguyen/libs/mongodb/bin
export PATH=$PATH:/Applications/MacVim.app/Contents/bin

# n (Node version manager)
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# Used by git commit
export VISUAL=nvim

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JAVA_HOME=$(/usr/libexec/java_home)
export IDEA_JDK=$JAVA_HOME
#. "$(brew --prefix nvm)/nvm.sh"
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

# Prompt {{{
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


# CUSTOM SCRIPTS {{{
for script in $HOME/.shared_shell_scripts/(sh|bash)/*.sh; do
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
