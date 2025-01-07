#!/bin/bash

# Variables
JENKINS_DIR="/var/lib/jenkins"
BACKUP_DIR="/srv/jenkinsbackup"
BACKUP_FILE="jenkins_backup_$(date +'%Y-%m-%d').zip"
S3_BUCKET="s3://jenkinsdevbackup"

# Create backup directory if it doesn't exist
#mkdir -p "$BACKUP_DIR"

# Stop Jenkins service
#sudo systemctl stop jenkins

# Zip the Jenkins directory
zip -r "$BACKUP_DIR/$BACKUP_FILE" "$JENKINS_DIR"

# Start Jenkins service
#sudo systemctl start jenkins

# Upload to S3
aws s3 cp "$BACKUP_DIR/$BACKUP_FILE" "$S3_BUCKET/"

# Clean up old backups locally (optional: older than 1 days)
find "$BACKUP_DIR" -type f -name "jenkins_backup_*.zip" -mtime +1 -exec rm {} \;