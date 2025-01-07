#!/bin/bash

# Update the PATH to include kubectl and aws
export PATH=/usr/local/bin:$PATH

# Define variables
SECRET_NAME="ecr-secret"
NAMESPACE="production"
ECR_REGISTRY="919314377239.dkr.ecr.ap-south-1.amazonaws.com"
AWS_REGION="ap-south-1"
DOCKER_EMAIL="abc@xyz.in"

# Delete the existing secret
kubectl delete secret $SECRET_NAME -n $NAMESPACE

# Recreate the secret
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=$ECR_REGISTRY \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password --region $AWS_REGION) \
  --docker-email=$DOCKER_EMAIL \
  -n $NAMESPACE

# Print status
if [ $? -eq 0 ]; then
  echo "Secret '$SECRET_NAME' in namespace '$NAMESPACE' has been successfully updated."
else
  echo "Failed to update secret '$SECRET_NAME' in namespace '$NAMESPACE'."
  exit 1
fi