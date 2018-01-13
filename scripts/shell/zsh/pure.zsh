#
# pure
#
prompt_exit_code=%(?.. [%?]) # My variable, not pure's.
prompt_newline='%666v' # Pure's recommended hack for single-line prompt
PROMPT="$prompt_exit_code $PROMPT"

# Print newline before prompt. Pure does this, but this behaviour is lost when we use prompt_newline.
precmd() { print "" }

