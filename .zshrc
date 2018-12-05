#zmodload zsh/zprof

# Use emacs bindings
bindkey -e


#
# zsh-nvm
#
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true


#
# zplug
#
export ZPLUG_HOME=$(brew --prefix zplug)
source $ZPLUG_HOME/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
zplug "lukechilds/zsh-nvm", from:github

# Install plugins that haven't been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Update plugins on the first of the month
curr_date=$(date +%d)
if [ $curr_date -eq '01' ]; then;
  zplug update
fi
unset curr_date


#
# CUSTOM SCRIPTS
#
for script ($HOME/scripts/shell/(zsh|sh)/*.(zsh|sh)) source $script


#
# LIBRARIES, BINARIES, TOOLS, etc.
#
export PATH=$PATH:$HOME/libs/gradle-2.14.1/bin
export PATH=$PATH:/Applications/MacVim.app/Contents/bin

export JAVA_HOME=$(/usr/libexec/java_home)
export IDEA_JDK=$JAVA_HOME


#
# ALIASES
#
alias ls="ls -Gh"
alias rg="rg --smart-case"
alias config='/usr/bin/git --git-dir=$HOME/.myconfig/ --work-tree=$HOME'

#
# Google Cloud SDK
#
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/cnguyen/libs/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/cnguyen/libs/google-cloud-sdk/completion.zsh.inc'; fi

#zprof

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
