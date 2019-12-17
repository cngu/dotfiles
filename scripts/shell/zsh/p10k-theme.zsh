POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"

typeset -g POWERLEVEL9K_CUSTOM_STATUS="prompt_zsh_status"
#POWERLEVEL9K_CUSTOM_STATUS_BACKGROUND="blue"
typeset -g POWERLEVEL9K_CUSTOM_STATUS_FOREGROUND="red"

prompt_zsh_status() {
  if [ $_p9k_status -ne 0 ]; then
    echo "[$_p9k_status]"
  fi
}

typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir                       
  vcs                       
  context                   
  custom_status            # custom
  newline                  
  virtualenv              
  prompt_char            
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  command_execution_time    # custom, removed from LEFT
)
