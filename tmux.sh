#!/bin/bash

#USAGE: It creates a tmux environment by using a .tmux.env file

source lib/functions.sh

# Manage errors:
if [ ! $# -eq 1 ]; then
  print_error "Invalid number of argument expected 1, given $#"
fi

if [ ! -r $1 ]; then
  print_error "The file $1 don't exists or read permission are not granted"
fi

# Loop through each line of the cleaned file
clean_file $1 | while read line
do
  split "$line" # Split line and create ARRAY variable

  DIR=${ARRAY[1]}
  NAME=${ARRAY[2]}
  COMMAND=${ARRAY[3]}

  case "${ARRAY[0]}" in
    "s")
      create_session "$DIR" "$NAME" "${ARRAY[5]}"
      ;;
    "w")
      create_window "$DIR" "$NAME"
      ;;
    "pv" | "ph")
      create_pane
      ;;
  esac
done

# Finally attach to the last created session
tmux attach -t "$SESSION"

