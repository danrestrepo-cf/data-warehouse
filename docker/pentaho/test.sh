#!/usr/bin/env bash

script_filename=${0##*/}
project_name=edw

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

function print_usage()
{
  echo "${script_filename} -- script usage"
  echo " "
  echo " Job Mode - pass in the path to a job you want kitchen to run and a file you want to be processed."
  echo "    Usage: ${script_filename} job [job_name] [filename]"
  echo "    Example: ./${script_filename} job /encompass/import/SP6/full_encompass_etl encompass.csv"
  echo " "
  echo " MDI Mode - pass in the process name configured in the EDW, a file name that should be checked for existence and a unique identifier."
  echo "    Usage: ${script_filename} mdi [process_name] [filename]"
  echo "    Example: ./${script_filename} mdi SP10.1 dmi-V35.xls"
}

function run_docker()
{
  if [[ "$machine" == "Win" ]]; then
    #set git bash so it does not convert paths using POSIX standard
    export MSYS_NO_PATHCONV=1
  fi

  docker run -it  \
    --network ${project_name}_default \
    -v $(pwd)/../../pentaho/src:/jobs/ \
    -v $(pwd)/inputs/:/input/ \
    --env DB_ENDPOINT=${project_name}_database_1 \
    --env DB_PORT=5432 \
    --env DB_USERNAME=postgres \
    --env DB_PASSWORD=testonly \
    --env PROCESS_NAME=${process_name} \
    --env INPUT_FILE="$filename" \
    --env INPUT_PATH=/input/ \
    ${project_name}/pentaho \
    j $job_name

  if [[ "$machine" == "Win" ]]; then
    #remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
    unset MSYS_NO_PATHCONV
  fi
}


parameter_count=3
if [[ $# -ne parameter_count ]]; then
   echo "ERROR: Unexpected number of parameters found. Expected ${parameter_count} but found ${#}."
   echo " "
   print_usage
  exit 1
fi


case "$1" in
mdi)
  shift 1
  process_name=$1 # SP10.1
  job_name="mdi/controller"
  filename=$2
  run_docker
  ;;
job)
  shift 1
  job_name=$1 # /src/encompass/import/SP6/full_encompass_etl
  filename=$2
  run_docker
  ;;
*)
  print_usage
  ;;
esac
