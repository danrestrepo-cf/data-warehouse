#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: aws-ecr-login.sh [account id]"
  exit 1
fi

account_id=$1
aws ecr get-login-password | docker login --username AWS --password-stdin ${account_id}.dkr.ecr.us-east-1.amazonaws.com
