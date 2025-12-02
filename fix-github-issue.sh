#!/bin/bash

set -e  # Exit immediately if any command fails

# Check if issue number is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <issue-number>"
    exit 1
fi

ISSUE_NUMBER=$1

# Get the directory where this script exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the directory where the script was invoked from
INVOKE_DIR="$(pwd)"

# Run git pull in the script's directory
echo "Running git pull in $SCRIPT_DIR..."
cd "$SCRIPT_DIR" && git pull

# Return to the invocation directory and run the uvx command
echo "Running fix-issue-with-kilocode in $INVOKE_DIR..."
cd "$INVOKE_DIR" && uvx --refresh --from "$SCRIPT_DIR" fix-issue-with-kilocode "$ISSUE_NUMBER" --timeout off
