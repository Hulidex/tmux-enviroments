#!/bin/bash

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
  if [ $# -eq 1  ];then
    NAME=$1
    tmux new-session -d -s "$NAME"
  else
    DIR=$2
    NAME=$1
    tmux new-session -d -c "$DIR" -s "$NAME"
  fi

  # This three variables are used by the whole script and in other functions
  SESSION="$NAME" # set the current session
  # This line is very important, for more details go to 'create_window' function
  WINDOW=''
}

create_window() {
  # When a session is created, a window is created within it, so later on if
  # we want to create a window we have to rename it instead of creating a new one.
  # So if $WINDOW doesn't exist (or is empty), just rename the default window.
  if [ -z "$WINDOW" ]; then
    tmux rename-window -t "$SESSION" "$1"
  else
    tmux new-window -n "$1"  -t "$SESSION"
  fi

  WINDOW="$1" # set the current window
  PANE=0 #Everytime a window is created we must reset PANE number

  if [ $# -gt 1 ]; then
    if [ $# -eq 2 ]; then
      # If just two arguments are passed, we must determinate if  the second
      # argument it's a path or a command
      if [ ${2:0:1} = '/' ]; then
        COMMAND="cd $2"
      else
        COMMAND="$2"
      fi
    else
      # Otherwise the second paramater is a path an the third a command
      COMMAND="cd $2 && $3"
    fi

    # Execute the command
    tmux send-keys -t "$SESSION:$WINDOW" "$COMMAND" ENTER
  fi
}

create_pane() {
    SPLIT_OPTION="-${ARRAY[0]:1:1}" # Access the second position of the string contained in ARRAY[0]
    tmux split-window $SPLIT_OPTION -t "${SESSION}:${WINDOW}.${PANE}"
    PANE=$(expr $PANE + 1)

    if [ $# -gt 0 ]; then
      if [ $# -eq 1 ]; then
        # If just two arguments are passed, we must determinate if  the second
        # argument it's a path or a command
        if [ ${1:0:1} = '/' ]; then
          COMMAND="cd $1"
        else
          COMMAND="$1"
        fi
      else
        COMMAND="cd $1 && $2"
      fi

      tmux send-keys -t "${SESSION}:${WINDOW}.${PANE}" "$COMMAND" ENTER
    fi
}
