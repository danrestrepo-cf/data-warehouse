#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
  echo "Usage: ./aws-sso-login.sh [environment]"
  exit 1
fi

environment=$1
if [ "$environment" == 'qa' ]; then
  echo "Using QA environment."
elif [ "$environment" == "uat" ]; then
  echo "UAT not supported yet."
  exit 1
elif [ "$environment" == "prod" ]; then
  echo "Using Production environment."
else
  echo "Unknown $environment supplied."
  exit 1
fi

profile="${environment}-data-warehouse-readonly"

# set MSYS_NO_PATHCONV to 1 so GitBash doesn't mangle path ~ gets turned into
export MSYS_NO_PATHCONV=1

docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli sso login --profile "${profile}"
