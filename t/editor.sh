#!/bin/bash
#
# This is a test editor for automating edits in the t/*.t scripts.
# It reads the ENV to write stuff to the given file.

# Exit on error
set -e

file="$1"

case "$TEST_EDIT_CMD" in
    die)
        echo "Error: exit with error as requested by TEST_EDIT_CMD" 1>&2
        exit 1
        ;;
    write|*)
        if [ -z "$file" ]; then
            echo "Error: no filename specified" 1>&2
            exit 1
        fi

        if [ -z "$TEST_EDIT" ]; then
            touch "$file"
        else
            echo -n "$TEST_EDIT" > "$file"
        fi
        ;;
esac

exit
