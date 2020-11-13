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

project_name=edw


if [[ "$machine" == "Win" ]]; then
  #set git bash so it does not convert paths using POSIX standard
  export MSYS_NO_PATHCONV=1
fi


docker run -it  \
  --network ${project_name}_default \
  -v $(pwd)/../../pentaho:/jobs/ \
  -v $(pwd)/inputs/:/input/ \
  --env DB_ENDPOINT=${project_name}_database_1 \
  --env DB_PORT=5432 \
  --env DB_USERNAME=postgres \
  --env DB_PASSWORD=testonly \
  --env INPUT_FILE="$filename" \
  --env INPUT_PATH=/input \
  ${project_name}/pentaho \
  bash


if [[ "$machine" == "Win" ]]; then
  #remove the environment variable used so Git Bash won't convert paths to the POSIX standard for the system
  unset MSYS_NO_PATHCONV
fi
