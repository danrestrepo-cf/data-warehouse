#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
  echo "Usage: ./aws-database-token.sh [environment]"
  exit 1
fi

environment=$1
RDS_ENDPOINT=""
if [ "$environment" == 'qa' ]; then
  echo "Using QA environment."
  RDS_ENDPOINT="qa-data-warehouse.cluster-cmpcw6cvsrlr.us-east-1.rds.amazonaws.com"
elif [ "$environment" == "uat" ]; then
  echo "UAT not supported yet."
  exit 1
elif [ "$environment" == "prod" ]; then
  echo "Using Production environment."
  RDS_ENDPOINT="prod-data-warehouse.cluster-cymvd4vzfjnm.us-east-1.rds.amazonaws.com"
else
  echo "Unknown $environment supplied."
  exit 1
fi
AWS_REGION="us-east-1"
DB_USER="readonly"
profile="${environment}-data-warehouse-readonly"

# set MSYS_NO_PATHCONV to 1 so GitBash doesn't mangle path ~ gets turned into
export MSYS_NO_PATHCONV=1

docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli rds generate-db-auth-token \
  --profile ${profile} \
  --hostname ${RDS_ENDPOINT} \
  --port 5432 \
  --region ${AWS_REGION} \
  --username ${DB_USER} \
  --output text
