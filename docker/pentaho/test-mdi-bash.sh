#!/usr/bin/env bash

project_name=edw
if [[ $# -ne 3 ]]; then
  echo "Usage: ./test-mdi-win.sh [process_name] [filename] [etl_batch_id]"
  echo "Example: ./test-mdi-win.sh SP10.1 dmi-V35.xls 77d65947-d152-4fab-8c7e-d64594580d69"
  exit 1
fi

process_name=$1
filename=$2
etl_batch_id=$3

#set git bash so it does not convert paths using POSIX standard
export MSYS_NO_PATHCONV=1

docker run -it  \
  --network ${project_name}_default \
  -v $(pwd)/../../pentaho:/jobs/ \
  -v $(pwd)/inputs/:/input/ \
  --env DB_ENDPOINT=edw_database_1 \
  --env DB_PORT=5432 \
  --env DB_USERNAME=postgres \
  --env DB_PASSWORD=testonly \
  --env DB_SCHEMA=dmi \
  --env PROCESS_ID=${process_name} \
  --env ETL_BATCH_ID=${etl_batch_id} \
  --env INPUT_FILE="$filename" \
  --env INPUT_PATH=/input \
  edw/pentaho \
  bash


#remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
unset MSYS_NO_PATHCONV
