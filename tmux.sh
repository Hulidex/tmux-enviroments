#!/bin/bash

#USAGE: It creates a tmux environment by using a .tmux.env file
LIB="$(dirname $0)/lib/*.sh"
#source all files under lib/ directory with .sh extension
for file in $LIB; do source $file; done

# Manage errors:
if [ ! $# -eq 1 ]; then
  print_error "Invalid number of argument expected 1, given $#"
fi

if [ ! -r $1 ]; then
  print_error "The file $1 don't exists or read permission are not granted"
fi

# Kill tmux (panes, windows, sessions...) before create anything
# MAYBE MAKE THIS LINE OPTIONAL???
tmux kill-server 2> /dev/null
sleep 2 # Sleep some time to wait tmux to kill everything

# Loop through each line of the cleaned file
clean_file $1 | while read line
do
  split "$line" # Split line and create ARRAY variable

  ARRAY_LENGTH=${#ARRAY[@]}
  DIR=${ARRAY[1]}
  NAME=${ARRAY[2]}
  COMMAND=${ARRAY[3]}

  case "${ARRAY[0]}" in
    "s")
      if [ $ARRAY_LENGTH -eq 2 ]; then
        create_session "${ARRAY[1]}" # If the NAME of session is given
      else
        # If the DIRECTORY and the NAME of the sesssion are given
        create_session "${ARRAY[1]}" "${ARRAY[2]}"
      fi
      ;;
    "w")
      if [ $ARRAY_LENGTH -eq 2 ]; then
       create_window "${ARRAY[1]}" # If the NAME of window is given
      elif [ $ARRAY_LENGTH -eq 3 ]; then
        #if the DIRECTORY and the NAME of the window are given
       create_window "${ARRAY[1]}" "${ARRAY[2]}"
      else
        #if the DIRECTORY, the NAME and a COMMAND are given
       create_window "${ARRAY[1]}" "${ARRAY[2]}" "${ARRAY[3]}"
      fi
      ;;
    "pv" | "ph")
      if [ $ARRAY_LENGTH -eq 1 ]; then
        create_pane
      elif [ $ARRAY_LENGTH -eq 2 ]; then
        create_pane "${ARRAY[1]}"
      else
        create_pane "${ARRAY[1]}" "${ARRAY[2]}"
      fi
      ;;
  esac
done

# Finally attach to the last created session
tmux attach -t "$SESSION"

