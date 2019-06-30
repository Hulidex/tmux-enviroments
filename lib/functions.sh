#!/bin/bash
#!/bin/bash
# FUNCTIONS

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


