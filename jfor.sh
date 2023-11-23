#!/bin/bash

# Check if a command is passed as a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 'command'"
    exit 1
fi

# Make sure list.txt exists
if [ ! -f list.txt ]; then
    echo "Error: File 'list.txt' not found!"
    exit 1
fi

# Store the command from the first parameter
COMMAND="$1"

# Loop through each line in list.txt
while IFS= read -r line
do
    # Run the command with the line as an argument
    $COMMAND "$line"
done < list.txt
