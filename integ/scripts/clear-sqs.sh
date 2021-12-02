#!/usr/bin/env bash

set +e
set +x

if [ $# -ne 1 ]; then
  echo "Usage: clear-sqs.sh [environment]"
  exit 1
fi

name_prefix="$1-bi-managed"

queues=$(aws sqs list-queues --queue-name-prefix "${name_prefix}" --output text --query "QueueUrls")
while read -r queue; do
  echo "Clearing $queue"
  aws sqs purge-queue --queue-url "${queue}"
done <<<"${queues}"
