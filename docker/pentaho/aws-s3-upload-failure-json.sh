#!/usr/bin/env bash

set -e
set -x

output_message=${1}

failure_message="{\"token_id\":\"${TOKEN_ID}\", \"output\":\"${output_message}\"}"
s3_failure_key="step-function-response/pending/failure/${ETL_BATCH_ID}"

echo "Attempting upload to s3://${S3_BUCKET}/${s3_failure_key} with contents of: ${failure_message}"

echo "${failure_message}" | aws s3 cp - "s3://${S3_BUCKET}/${s3_failure_key}"
