#!/bin/bash
# Copyright (C) David Joffe 2023-2024

# Check if a command is passed as a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 'command'"
    exit 1
fi

# Store the command from the first parameter
COMMAND="$1"

# Loop through each subfolder in the current directory
for dir in */ ; do
    # Check if the directory is indeed a directory
    if [ -d "$dir" ]; then
        echo "Executing in $dir"
        
        # Change directory to the subfolder
        cd "$dir"

        # Execute the command and ignore errors
        $COMMAND "$2"   || true

        # Go back to the parent directory
        cd ..
    fi
done

