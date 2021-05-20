#!/usr/bin/env bash

# set the script to fail on any errors
set -e

# set the script to print all commands to the screen
set -x

# check number of parameters passed in
if [ $# -ne 3 ]; then
  echo "Usage: s3-artifact-download.sh [local_path] [local_file] [s3_key]"
  exit 1
fi

local_path="$1"
local_file="$2"
s3_key="$3"
s3_bucket="dev-jenkins-asset-storage-s3"

# download artifact
aws s3 cp "s3://${s3_bucket}/${s3_key}" "${local_path}/${local_file}"
