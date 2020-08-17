#!/usr/bin/env bash

project_name=edw
if [[ $# -ne 2 ]]; then
  echo "Usage: test.sh [job_name] [filename]"
  exit 1
fi

job_name=$1 # /encompass/import/SP6/full_encompass_etl
filename=$2

#set git bash so it does not convert paths using POSIX standard
export MSYS_NO_PATHCONV=1

#this command works to load the details (everything is hardcoded, all -param: parameters are ignored currently)
#./kitchen.sh -rep=PentahoFileRepository -level=Detailed -job=/encompass/import/SP6/full_encompass_etl -param:database_hostname=edw_database_1 -param:input_path=/inputs/ -param:log_path=/inputs/ -param:database_password=testonly -param:database_username=postgres

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

#remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
unset MSYS_NO_PATHCONV