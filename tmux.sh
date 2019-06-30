#!/bin/bash

#USAGE: It creates a tmux environment by using a .tmux.env file

source lib/functions.sh

# VARS
SESSION=''
WINDOW=''
PANE=0

if [ ! $# -eq 1  ]; then
  echo "$(tput setaf 1)ERROR: $(tput setaf 4) Invalid number of argument expected 1, given $#$(tput sgr0)"
  exit 1
fi

if [ ! -r $1 ]; then
  echo "$(tput setaf 1)ERROR: $(tput setaf 4)The file $(tput setaf 2)$1 $(tput setaf 4)don't exists or read permission are not granted$(tput sgr0)"
  exit 1
fi

# Loop through each line of the cleaned file
clean_file $1 | while read line
do
  split "$line"

  DIR=${ARRAY[1]}
  NAME=${ARRAY[2]}
  COMMAND=${ARRAY[3]}

  case "${ARRAY[0]}" in
    "s")
      tmux new-session -d -c "$DIR" -s "$NAME"
      SESSION="$NAME"
      WINDOW=''
      ;;
    "w")
      if [ -z "$WINDOW" ]; then # if $WINDOW_NAME doesn't exist, just rename the default window
        COMMAND="cd $DIR && ${ARRAY[3]}"
        tmux rename-window -t "$SESSION" "$NAME"
        WINDOW="$NAME"
      else
        tmux new-window -c "$DIR" -n "$NAME"  -t "$SESSION"
        WINDOW="$NAME"
      fi

      tmux send-keys -t "$SESSION:$WINDOW" "$COMMAND" ENTER
      ;;
    "pv" | "ph")
      COMMAND=${ARRAY[2]}
      SPLIT_OPTION="-${ARRAY[0]:1:1}" # Access the second position of the string contained in ARRAY[0]
      tmux split-window $SPLIT_OPTION -c "$DIR" -t "${SESSION}:${WINDOW}.${PANE}"
      PANE=$(expr $PANE + 1)
      tmux send-keys -t "${SESSION}:${WINDOW}.${PANE}" "$COMMAND" ENTER
      ;;
  esac
done

# Finally attach to the last created session
tmux attach -t "$SESSION"

