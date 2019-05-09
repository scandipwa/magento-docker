#!/bin/bash

# On local setup drop privileges to `user` with a mapped UID taken from host mount

# Set permissions for non privileged users to use stdout/stderr
chmod augo+rwx /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2

# Check if set UID variable, if empty, execute as root
if [[ -n "$LOCAL" ]]; then
  
  HOST_UID=$(stat -c "%u" $BASEPATH)

  echo "Starting with UID : $HOST_UID"
  useradd --shell /bin/bash -u $HOST_UID -o -c "" -m user
  export HOME=/home/user

  exec gosu user "$@"

else
  echo "Starting as root"
  exec "$@"
fi 
