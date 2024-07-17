#!/bin/bash

# Source the configuration file
. ${HOME}/etc/shell.conf

# Check if the password argument is provided
if [ -z "$1" ]; then
    echo "Error: No password provided."
    echo "Usage: $0 <password>"
    exit 1
fi

# Assign the first argument to PW
PW="$1"

# Iterate over the list of frames and execute the command to kill Chromium processes on the slaves
for lg in $LG_FRAMES; do
  if [ $lg != "lg1" ]; then
    # Use sshpass for password-based SSH login and kill Chromium processes
    sshpass -p $PW ssh -n $lg "export DISPLAY=:0; pkill chromium-browse; pkill chrome" &
  fi
done

# Kill Chromium processes on the master
export DISPLAY=:0
pkill chromium-browse
pkill chrome
