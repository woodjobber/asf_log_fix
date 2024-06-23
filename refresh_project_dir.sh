#!/bin/bash

# Set the project directory path
PROJECT_DIR=$(pwd)

# Navigate to the project directory
cd "$PROJECT_DIR" || { echo "Project directory not found!"; exit 1; }

# Use the find command to touch all files
find . -type f -exec touch {} +

# Print a message indicating the operation is complete
echo "All files in the project directory have been 'touched'."
