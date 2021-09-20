#!/usr/bin/env bash

set -e
set -x

output_message=${1}
etl_batch_id=${2}
environment_name=${3}

failure_message="{\"token_id\":\"${TOKEN_ID}\", \"output\":\"${output_message}\"}"
s3_failure_bucket="${environment_name}-data-warehouse-ingress"
s3_failure_key="step-function-response/pending/failure/${etl_batch_id}"
s3_uri="s3://${s3_failure_bucket}/${s3_failure_key}"

echo "Attempting upload to ${s3_uri} with contents of: ${failure_message}"

echo "${failure_message}" | aws s3 cp - "${s3_uri}"
