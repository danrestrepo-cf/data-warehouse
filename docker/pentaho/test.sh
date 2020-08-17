#!/usr/bin/env bash

project_name=edw
if [[ $# -ne 2 ]]; then
  echo "Usage: test.sh [job_name] [filename]"
  exit 1
fi

job_name=$1 # /encompass/import/SP6/full_encompass_etl
filename=$2

docker run -it  \
  --network ${project_name}_default \
  -v $(pwd)/../../pentaho:/jobs/ \
  -v $(pwd)/inputs/:/inputs/ \
  --env DB_ENDPOINT=edw_database_1 \
  --env DB_PORT=5432 \
  --env DB_USERNAME=postgres \
  --env DB_PASSWORD=testonly \
  --env INPUT_PATH=/inputs/ \
  --env INPUT_FILE="$filename" \
  --rm edw/pentaho \
  j ${job_name}
