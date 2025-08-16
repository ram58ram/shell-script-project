#! /bin/bash

echo "All variables that passed to script: $@"
echo "Total number of arguments passed: $#"
echo "File name: $0"
echo "First argument: $1"
echo "Current working directory: $PWD"
echo "User ID of the current user: $UID"
echo "Home directory of the current user: $HOME"
echo "Current shell process ID: $$"
sleep 100 &  # Run in background
echo "PID of last background command: $!"
echo "Last command exit status: $?"