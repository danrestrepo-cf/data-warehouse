#!/usr/bin/env bash

path_to_script=$(realpath $(dirname "$0"))

# stop script execution if any command fails
set -e

# set variable defaults
script_filename=${0##*/}
project_name=edw

# set default directories docker will use to mount in the docker container
pentaho_source_directory="$path_to_script/../../pentaho/src"
pentaho_input_directory="$(pwd)/inputs/"

entrypoint_parameter="j "

# determine what type of machine we're running on
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) machine=Linux ;;
Darwin*) machine=Mac ;;
CYGWIN*) machine=Win ;;
MINGW*) machine=Win ;;
*) machine="UNKNOWN:${unameOut}" ;;
esac

function print_usage() {
  echo "${script_filename} -- script usage"
  echo " "
  echo " Job Mode - pass in the path to a job you want kitchen to run and a file you want to be processed."
  echo "    Usage: ${script_filename} job [job_name] [username] [input_type:none|file] [input filename]"
  echo "    Example: ./${script_filename} job /encompass/import/SP6/full_encompass_etl encompass_sp6 file encompass.csv"
  echo " "
  echo " MDI Mode - pass in the process name configured in the EDW and a file name that should be checked for existence."
  echo "    Usage: ${script_filename} mdi [process_name] [username] [input_type:none|file] [input filename]"
  echo "    Example: ./${script_filename} mdi SP10.1 dmi file dmi-V35.xls"
  echo " "
  echo " Unit Test Mode - pass in the process name configured in the EDW, a file name that should be checked for "
  echo "                  existence, and the path to the job/transformation that kitchen should execute."
  echo "    Usage: ${script_filename} test [process_name] [username] [transformation/job to run] [input_type:none|file] [input filename]"
  echo "    Example: ./${script_filename} test \"SP8.1\" dmi \"mdi/controller\" file \"dmi-V35-state.csv\""
  echo "        or"
  echo "    Example: ./${script_filename} test \"SP8.2\" dmi \"mdi/controller\" none"
  echo " "
  echo " Bash Mode - run docker and launch bash instead of executing a Pentaho process."
  echo "    Usage: ${script_filename} bash"
  echo "    Example: ./${script_filename} bash"
  echo " "
}

function run_docker() {
  if [[ "$machine" == "Win" ]]; then
    # set git bash so it does not convert paths using POSIX standard
    export MSYS_NO_PATHCONV=1
  fi

  docker_command="docker run -i ${tty_parameter} \
    --network ${project_name}_default \
    -v ${pentaho_source_directory}:/jobs/ \
    -v ${pentaho_input_directory}:/input/ \
    --env DB_ENDPOINT=${project_name}_database_1 \
    --env DB_PORT=5432 \
    --env DB_USERNAME=${username} \
    --env DB_PASSWORD=testonly \
    --env PROCESS_NAME=${process_name} \
    --env INPUT_FILE=${filename} \
    --env INPUT_PATH=/input/ \
    --env INPUT_TYPE=${input_type} \
    ${project_name}/pentaho \
    ${entrypoint_parameter} ${job_name}"

  ${docker_command} # execute the generated docker command

  if [[ "$machine" == "Win" ]]; then
    # remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
    unset MSYS_NO_PATHCONV
  fi
}

case "$1" in
mdi)
  # ensure correct number of parameters passed in for MDI Mode
  if [[ "$#" -ne "5" ]]; then
    echo "Could not understand input parameters. MDI mode expects the first parameter to $script_filename to be 'mdi' and have 5 parameters in total but found $#."
    echo "Displaying script usage:"
    print_usage
    exit 1
  fi

  shift 1
  process_name=$1 # SP10.1
  job_name="mdi/controller"
  username=$2
  input_type=$3
  filename=$4
  run_docker
  ;;
job)
  # ensure correct number of parameters passed in for Job Mode
  if [[ "$#" -ne "5" ]]; then
    echo "Could not understand input parameters. Job mode expects the first parameter to $script_filename to be 'job' and have 4 parameters in total but found $#."
    echo "Displaying script usage:"
    print_usage
    exit 1
  fi

  shift 1
  job_name="$1" # /encompass/import/SP6/full_encompass_etl
  username=$2
  input_type=$3
  filename=$4
  run_docker
  ;;
test)
  # ensure correct number of parameters passed in for Unit Test Mode
  if [[ "$#" -ne "6" ]]; then
    echo "Could not understand input parameters. Unit Test mode expects the first parameter to $script_filename to be 'test' and have 5 parameters in total but found $#."
    echo "Displaying script usage:"
    print_usage
    exit 1
  fi

  shift 1
  process_name=$1 # Ex: "SP10.1"
  filename=$5     # Ex: "Encompass.csv"
  username=$2
  input_type=$4
  job_name=$3 # Ex: "mdi/controller" or "encompass/import/SP6/full_encompass_etl"
  run_docker
  ;;
bash)
  shift 1
  filename="dummy_value"
  entrypoint_parameter=""
  process_name="bash"
  job_name="bash"
  entrypoint_parameter=""
  input_type="none"
  username="dummy_value"
  tty_parameter="--tty"
  run_docker
  exit 0
  ;;
*)
  echo "Could not understand input parameters. Displaying script usage:"
  print_usage
  exit 1
  ;;
esac
