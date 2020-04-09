# Handle no arguments passed
FILE_COUNT=$#
[ $FILE_COUNT -ge 1 ] || (echo "At least 1 argument required, $# provided" && exit 1)

# Waits for file passed as argument
INTERVAL=1
function wait_for_file {
  while ! [ -f "./$1" ]; do
    sleep $INTERVAL
  done
}

# Waits for the passed process to finish
function check_for_process_running {
  pid=$(pgrep bash | grep $1)
  return $?
}

# Entry point
declare -a pending_processes

for FILE_RELATIVE_PATH in "$@"; do
  wait_for_file "$FILE_RELATIVE_PATH" &
  pending_processes+=($!)
done

while ! [ -z "$pending_processes" ]; do
  for PENDING_PROC in "${pending_processes[@]}"; do
    if ! check_for_process_running $PENDING_PROC; then
      delete=($PENDING_PROC)
      pending_processes=( ${pending_processes[@]/$delete} )
    fi
  done
  sleep 5
done

echo "All files are present"
# TODO implement launching script passed as parameter