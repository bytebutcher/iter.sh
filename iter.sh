#!/bin/bash
# ##################################################
# NAME:
#   iter.sh
# DESCRIPTION:
#   Efficiently process structured text files with 
#   customizable field handling for command execution.
# AUTHOR:
#   bytebutcher
# ##################################################

APP_NAME="$(basename "${BASH_SOURCE}")"

# Usage explanation
usage() {
    echo "Usage: $APP_NAME [-f file] [-d delimiter] [-c column_names] <command>"
    echo
    echo "Examples: "
    echo ""
    echo "  # Print every line of a text file"
    echo "  $APP_NAME -f data.txt 'echo \$line'"
    echo ""
    echo "  # Print every line of a csv file"
    echo "  $APP_NAME -f data.txt -d ',' -c 'name,namespace' 'echo \$name is in \$namespace'"
    echo ""
    echo "  # Pipe into iter and print every line of a csv file"
    echo "  cat data.txt | $APP_NAME -d ',' -c 'name,namespace' 'echo \$name is in \$namespace'"
    echo ""
    exit 1
}

# Parse arguments
delimiter=""  # Default to no delimiter (whole line)
declare -a columns=("line")  # Default column name
file=""

# Parse arguments
while getopts "d:c:f:" opt; do
    case $opt in
        d) delimiter="$OPTARG";;  # Set delimiter
        c) IFS=',' read -ra columns <<< "$OPTARG";;  # Read column names into array
        f) file="$OPTARG";;  # File to read from
        \?) usage;;  # Show usage and exit on unknown option
    esac
done
shift $((OPTIND - 1))

# Remaining argument should be the command
if [ "$#" -lt 1 ]; then
    usage
fi
command="$1"

# Check if the file exists
if [ -n "$file" ] && [ ! -f "$file" ]; then
    echo "Error: File specified does not exist."
    exit 1
fi

if [ -n "$file" ]; then
    exec < "$file"
fi

# Execute command on each line of the file
while IFS="$delimiter" read -ra line_data; do
    # Setting up dynamic variables based on column names
    if [ -n "$delimiter" ]; then
        for i in "${!columns[@]}"; do
            eval "${columns[i]}='${line_data[i]//\'/\'\\\'\'}'"
        done
    else
        eval "${columns[0]}='${line_data[*]//\'/\'\\\'\'}'"
    fi

    # Executing the command
    eval "$command"
done
