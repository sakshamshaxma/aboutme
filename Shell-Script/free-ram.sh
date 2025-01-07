#!/bin/bash
# free.sh - Script to drop cache and free up memory

# Exit immediately if a command exits with a non-zero status
set -e

# Drop caches by writing to /proc/sys/vm/drop_caches
echo "Dropping caches..."

# Drop only page cache
echo 1 > /proc/sys/vm/drop_caches
echo "Dropped page cache (echo 1)."

# Drop dentries and inodes
echo 2 > /proc/sys/vm/drop_caches
echo "Dropped dentries and inodes (echo 2)."

# Drop page cache, dentries, and inodes
echo 3 > /proc/sys/vm/drop_caches
echo "Dropped page cache, dentries, and inodes (echo 3)."

# Sync and drop caches again for consistency
sync && echo 1 > /proc/sys/vm/drop_caches
echo "Synced and dropped page cache (echo 1) after sync."

echo "Cache dropping completed."