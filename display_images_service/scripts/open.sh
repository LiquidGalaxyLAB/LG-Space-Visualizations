#!/bin/bash

# Check if password, image URL, and total screens are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sudo_password> <img_url> <total_screens>"
    exit 1
fi

# Assign the first argument to PW, the second to IMG_URL, the third to TOTAL_SCREENS, and set the PORT
PW=$1
IMG_URL=$2
TOTAL_SCREENS=$3
PORT=58607

export DISPLAY=:0.0

# Function to assign screen position based on the total number of screens
assign_screens() {
    if [ "$1" -eq 5 ]; then
        echo "lg4=1 lg5=2 lg1=3 lg2=4 lg3=5"
    elif [ "$1" -eq 3 ]; then
        echo "lg3=1 lg1=2 lg2=3"
    else
        echo "Unsupported screen count. Only 3 or 5 screens are supported."
        exit 1
    fi
}

# Get the screen assignments
screen_assignments=$(assign_screens $TOTAL_SCREENS)

# Extract the screen number for lg1 from the assignments
screen_lg1=$(echo $screen_assignments | grep -o "lg1=[0-9]" | cut -d'=' -f2)

# Start Chromium browser on lg1 in full screen
chromium-browser --start-fullscreen "http://localhost:$PORT/display?photo_url=$IMG_URL&current_screen=$screen_lg1&total_screen=$TOTAL_SCREENS" > /dev/null 2>&1 &

sleep 1

# Source the configuration file
. ${HOME}/etc/shell.conf

# Convert the LG_FRAMES variable to an array
lg_frames_array=($LG_FRAMES)

# Iterate over the screen assignments and execute commands
for assignment in $screen_assignments; do
    lg=$(echo $assignment | cut -d'=' -f1)
    screenNumber=$(echo $assignment | cut -d'=' -f2)
    if [ "$lg" != "lg1" ]; then
        sshpass -p $PW ssh -tXn $lg "export DISPLAY=:0; chromium-browser 'http://lg1:$PORT/display?photo_url=$IMG_URL&current_screen=$screenNumber&total_screen=$TOTAL_SCREENS' --start-fullscreen &" &
    fi
    sleep 1
done
