#!/usr/bin/env bash

script_filename=${0##*/}

# determine what type of machine we're running on
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Win;;
    MINGW*)     machine=Win;;
    *)          machine="UNKNOWN:${unameOut}"
esac
# echo ${machine}

function display_usage()
{
  echo "${script_filename} -- script usage"
  echo " "
  echo " Job Mode - pass in the path to a job you want kitchen to run and a file you want to be processed."
  echo "    Usage: ${script_filename} [job_name] [filename]"
  echo "    Example: ./${script_filename} /encompass/import/SP6/full_encompass_etl encompass.csv"
  echo " "
  echo " MDI Mode - pass in the process name configured in the EDW, a file name that should be checked for existance and a unique identifier."
  echo "    Usage: ${script_filename} [process_name] [filename] [etl_batch_id]"
  echo "    Example: ./${script_filename} SP10.1 dmi-V35.xls 77d65947-d152-4fab-8c7e-d64594580d69"
}

project_name=edw

# determine if we are in 'Job Mode' mode or 'MDI mode'
# Job Mode - pass in the path to a job you want kitchen to run and a file you want to be processed
# MDI Mode - pass in the process name configured in the EDW, a file name that should be checked for existance and
#   a unique identifier
execution_mode=none

if [[ $# -eq 2 ]]; then
  execution_mode="job_mode"
  job_name=$1 # /encompass/import/SP6/full_encompass_etl
elif [[ $# -eq 3 ]]; then
  execution_mode="mdi_mode"
  process_name=$1 # SP10.1
  etl_batch_id=$3
else
  echo "ERROR: unable to determine mode based on the number of parameters passed in!"
  echo ""
  display_usage
  exit 1;
fi

filename=$2

if [[ "$machine" == "Win" ]]; then
  #set git bash so it does not convert paths using POSIX standard
  export MSYS_NO_PATHCONV=1
fi

if [[ "${execution_mode}" == "job_mode" ]]; then
  echo "job"
  docker run -it  \
    --network ${project_name}_default \
    -v $(pwd)/../../pentaho:/jobs/ \
    -v $(pwd)/inputs/:/input/ \
    --env DB_ENDPOINT=${project_name}_database_1 \
    --env DB_PORT=5432 \
    --env DB_USERNAME=postgres \
    --env DB_PASSWORD=testonly \
    --env INPUT_PATH=/input \
    --env INPUT_FILE="$filename" \
    --rm ${project_name}/pentaho \
    j $job_name

  #prod commandline (DW2, ETL02)
  # C:\pentaho\data-iazntegration\kitchen.bat param:rep:Pentaho_Saves param:job:/DW_2_to_DW_1/Job/Staging_TMP_OctaneUsersFix param:level:Detailed > C:\pentaho\LogFiles\Staging_TMP_OctaneUsersFix_%YYYYMMDD%.log

elif [[ "${execution_mode}" == "mdi_mode" ]]; then
  echo "mdi"
  docker run -it  \
    --network ${project_name}_default \
    -v $(pwd)/../../pentaho:/jobs/ \
    -v $(pwd)/inputs/:/input/ \
    --env DB_ENDPOINT=${project_name}_database_1 \
    --env DB_PORT=5432 \
    --env DB_USERNAME=postgres \
    --env DB_PASSWORD=testonly \
    --env PROCESS_ID=${process_name} \
    --env ETL_BATCH_ID=${etl_batch_id} \
    --env INPUT_FILE="$filename" \
    --env INPUT_PATH=/input \
    ${project_name}/pentaho \
    j "mdi/controller"

fi

if [[ "$machine" == "Win" ]]; then
  #remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
  unset MSYS_NO_PATHCONV
fi
