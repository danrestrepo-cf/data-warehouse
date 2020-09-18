#!/usr/bin/env bash

#environment variable to tell Pentaho where to find the .kettle folder that has the
#repositories.xml (defines the repository root directory
export KETTLE_HOME=/jobs/

# Sets script to fail if any command fails.
set -e
# Do not set echo of commands, as the password is passed in (see if we can load in another way)

params=""
echo "Has DB_ENDPOINT? ${DB_ENDPOINT}"
if [[ -n "${DB_ENDPOINT}" ]]; then
  params="${params} -param:database_hostname=${DB_ENDPOINT}"
fi
echo "Has DB_PORT? ${DB_PORT}"
if [[ -n "${DB_PORT}" ]]; then
  params="${params} -param:database_port=${DB_PORT}"
fi
echo "Has DB_USERNAME? ${DB_USERNAME}"
if [[ -n "${DB_USERNAME}" ]]; then
  params="${params} -param:database_username=${DB_USERNAME}"
fi
if [[ -n "${DB_PASSWORD}" ]]; then
  echo "Has DB_PASSWORD."
  params="${params} -param:database_password=${DB_PASSWORD}"
else
  echo "Missing DB_PASSWORD"
fi
echo "Has INPUT_PATH? ${INPUT_PATH}"
if [[ -n "${INPUT_PATH}" ]]; then
  params="${params} -param:input_path=${INPUT_PATH}"
fi

download() {
  if [[ -n "${S3_BUCKET}" && -n "${S3_KEY}" ]]; then
    echo "Fetching input file from S3"
    /aws-s3-download.sh
  else
    echo "Not downloading from S3."
  fi

  full_input_file="${INPUT_PATH}/${INPUT_FILE}"
  if [[ ! -f $full_input_file ]]; then
    echo "Expecting file ${full_input_file} to exist, but it does not."
    exit 1
  fi
}

run_pan() {
  echo ./pan.sh -file /jobs/$@
  pan.sh -file /jobs/$@
}

run_kitchen() {
  echo ./kitchen.sh -rep=PentahoFileRepository -level=Detailed -job=$@
  # we want "params" to split / expand, so ignore the shellcheck
  # shellcheck disable=SC2086
  kitchen.sh -rep=PentahoFileRepository -level=Detailed ${params} -job=$@
  # kitchen.sh -rep=PentahoFileRepository -level=Detailed -job=/pentaho/encompass/import/SP6/full_encompass_etl -param:database_hostname=edw_database_1 -param:input_path=/inputs/ -param:log_path=/inputs/
}

print_usage() {
  echo "
Usage:	$0 COMMAND
Pentaho Data Integration (PDI)
Options:
  -j filename  Run job file
  -t filename  Run transformation file
"
}

case "$1" in
help)
  print_usage
  ;;
t)
  shift 1
  download
  run_pan "$@"
  ;;
j)
  shift 1
  download
  run_kitchen "$@"
  ;;
*)
  exec "$@"
  ;;
esac
