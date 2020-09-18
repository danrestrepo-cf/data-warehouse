#!/usr/bin/env bash

set -e
set -x

~/bin/aws s3 cp "s3://${S3_BUCKET}/${S3_KEY}" "${INPUT_PATH}${INPUT_FILE}"
