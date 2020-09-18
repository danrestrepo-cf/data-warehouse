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
  bash


#prod commandline (DW2, ETL02)
# C:\pentaho\data-iazntegration\kitchen.bat param:rep:Pentaho_Saves param:job:/DW_2_to_DW_1/Job/Staging_TMP_OctaneUsersFix param:level:Detailed > C:\pentaho\LogFiles\Staging_TMP_OctaneUsersFix_%YYYYMMDD%.log