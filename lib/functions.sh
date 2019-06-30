#!/bin/bash

# VARS

# Note that they are shared to the whole script, so you can use them
# inside a function, a reuse them outside that function... 
SESSION=''
WINDOW=''
PANE=0

# FUNCTIONS

#It prints a colored error and aborts execution of the script
print_error(){
  echo "$(tput setaf 1)ERROR: $(tput setaf 4) $1$(tput sgr0)"
  exit 1
}

# It receives a filename as the first argument and removes all the commentaries
# (lines preceded by character '#') empty lines and all leading witespaces or
# tabs of that file.
clean_file(){
  cat $1 | sed '/^#/d; /^$/d; s/^[ \t]*//'
}

# Check if the file has correct syntax, otherwise, it returns a
# message error and aborts the script
check_syntax(){
  # PENDING
  echo "pending"
  exit 1
}

# It receives a string and split them by delimiter ':', finally it stores
# the sub-strings on an Array named ARRAY.
split() {
  IFS=':'
  read -ra ARRAY <<< $1
}

create_session() {
  tmux new-session -d -c "$1" -s "$2"
  SESSION="$2"
  # This line is very important, for more details go to 'create_window' function
  WINDOW=''
}

create_window() {
  # When a session is created, a window is created within it, so later on if
  # we want to create a window we have to rename it instead of creating a new one.
  # So if $WINDOW doesn't exist (or is empty), just rename the default window.

  if [ -z "$WINDOW" ]; then
    COMMAND="cd $1 && ${ARRAY[3]}"
    tmux rename-window -t "$SESSION" "$2"
    WINDOW="$2"
  else
    tmux new-window -c "$1" -n "$2"  -t "$SESSION"
    WINDOW="$2"
  fi

  tmux send-keys -t "$SESSION:$WINDOW" "$COMMAND" ENTER
}

create_pane() {
    COMMAND=${ARRAY[2]}
    SPLIT_OPTION="-${ARRAY[0]:1:1}" # Access the second position of the string contained in ARRAY[0]
    tmux split-window $SPLIT_OPTION -c "$DIR" -t "${SESSION}:${WINDOW}.${PANE}"
    PANE=$(expr $PANE + 1)
    tmux send-keys -t "${SESSION}:${WINDOW}.${PANE}" "$COMMAND" ENTER
}
