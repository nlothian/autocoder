#!/bin/bash

set -e  # Exit immediately if any command fails

# Check if PR number is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <pr-number>"
    exit 1
fi

PR_NUMBER=$1

# Get the directory where this script exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the directory where the script was invoked from
INVOKE_DIR="$(pwd)"

# Run git pull in the script's directory
echo "Running git pull in $SCRIPT_DIR..."
cd "$SCRIPT_DIR" && git pull

# Return to the invocation directory and run the uvx command
echo "Running address-pr-comments-with-kilocode in $INVOKE_DIR..."
cd "$INVOKE_DIR" && uvx --refresh --from "$SCRIPT_DIR" address-pr-comments-with-kilocode "$PR_NUMBER" --timeout off
