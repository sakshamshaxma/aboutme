#!/bin/bash

# Directory to search
search_dir="/opt/java/"

# Find and delete .log files older than 2 days
echo "Searching for .log files older than 2 days in $search_dir..."
find "$search_dir" -type f -name "*.log" -mtime +2 -exec rm -f {} \;

echo "Old log files removed."