#!/usr/bin/env bash

# stop script execution if any command fails
set -e

# set variable defaults
script_filename=${0##*/}
project_name=edw

# set default directories docker will use to mount in the docker container
pentaho_source_directory=($(pwd)/../../pentaho/src)
pentaho_test_directory=($(pwd)/../../pentaho/test)
pentaho_input_directory=($(pwd)/inputs/)

job_type="j "

# determine what type of machine we're running on
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Win;;
    MINGW*)     machine=Win;;
    *)          machine="UNKNOWN:${unameOut}"
esac

function print_usage()
{
  echo "${script_filename} -- script usage"
  echo " "
  echo " Job Mode - pass in the path to a job you want kitchen to run and a file you want to be processed."
  echo "    Usage: ${script_filename} job [job_name] [filename]"
  echo "    Example: ./${script_filename} job /encompass/import/SP6/full_encompass_etl encompass.csv"
  echo " "
  echo " MDI Mode - pass in the process name configured in the EDW and a file name that should be checked for existence."
  echo "    Usage: ${script_filename} mdi [process_name] [filename]"
  echo "    Example: ./${script_filename} mdi SP10.1 dmi-V35.xls"
  echo " "
  echo " Unit Test Mode - pass in the process name configured in the EDW, a file name that should be checked for "
  echo "                  existence, and the path to the job/transformation that kitchen should execute."
  echo "    Usage: ${script_filename} test [process_name] [filename] [transformation/job to run]"
  echo "    Example: ./${script_filename} test \"SP8.1\" \"dmi-V35-state.csv\" \"mdi/controller\""
  echo " "
  echo " Bash Mode - run docker and launch bash instead of executing a Pentaho process."
  echo "    Usage: ${script_filename} bash"
  echo "    Example: ./${script_filename} bash"
  echo " "
}

function run_docker()
{
  if [[ "$machine" == "Win" ]]; then
    #set git bash so it does not convert paths using POSIX standard
    export MSYS_NO_PATHCONV=1
  fi

  docker run -it  \
    --network ${project_name}_default \
    -v ${pentaho_source_directory}:/jobs/ \
    -v ${pentaho_input_directory}:/input/ \
    --env DB_ENDPOINT=${project_name}_database_1 \
    --env DB_PORT=5432 \
    --env DB_USERNAME=postgres \
    --env DB_PASSWORD=testonly \
    --env PROCESS_NAME=${process_name} \
    --env INPUT_FILE="$filename" \
    --env INPUT_PATH=/input/ \
    ${project_name}/pentaho \
    $job_type $job_name

  if [[ "$machine" == "Win" ]]; then
    #remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
    unset MSYS_NO_PATHCONV
  fi
}

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
  job_name="$1" # /encompass/import/SP6/full_encompass_etl
  filename=$2
  run_docker
  ;;
test)
  shift 1
  process_name=$1   # Ex: "SP10.1"
  filename=$2       # Ex: "Encompass.csv"
  job_name="$3"       # Ex: "mdi/controller" or "/encompass/import/SP6/full_encompass_etl"
  pentaho_input_directory=${pentaho_test_directory}/${process_name}/
  run_docker
  ;;
bash)
  shift 1
  filename="empty.file"
  job_type=""
  pentaho_input_directory=("$pentaho_test_directory"/bash)
  process_name="bash"
  job_name="bash"
  run_docker
  exit 0
;;
*)
  echo "Could not understand input parameters. Displaying script usage:"
  print_usage
  ;;
esac
