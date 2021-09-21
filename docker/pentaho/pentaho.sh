#!/usr/bin/env bash

#environment variable to tell Pentaho where to find the .kettle folder that has the
#repositories.xml (defines the repository root directory
export KETTLE_HOME=/jobs/

# Sets script to fail if any command fails.
set -e
# Do not set echo of commands, as the password is passed in (see if we can load in another way)

params=""

echo "[INPUT] DB_ENDPOINT=${DB_ENDPOINT}"
if [[ -n "${DB_ENDPOINT}" ]]; then
  params="${params} -param:database_hostname=${DB_ENDPOINT}"
fi

echo "[INPUT] DB_PORT=${DB_PORT}"
if [[ -n "${DB_PORT}" ]]; then
  params="${params} -param:database_port=${DB_PORT}"
fi

echo "[INPUT] DB_USERNAME=${DB_USERNAME}"
if [[ -n "${DB_USERNAME}" ]]; then
  params="${params} -param:database_username=${DB_USERNAME}"
fi

if [[ -n "${DB_PASSWORD}" ]]; then
  echo "[INPUT] Has DB_PASSWORD."
  params="${params} -param:database_password=${DB_PASSWORD}"
else
  echo "[INPUT] Missing DB_PASSWORD"
fi

echo "[INPUT] INPUT_PATH=${INPUT_PATH}"
if [[ -n "${INPUT_PATH}" ]]; then
  params="${params} -param:input_path=${INPUT_PATH}"
fi

echo "[INPUT] PROCESS_NAME=${PROCESS_NAME}"
if [[ -n "${PROCESS_NAME}" ]]; then
  params="${params} -param:process_name=${PROCESS_NAME}"
fi

echo "[INPUT] AWS_ENVIRONMENT=${AWS_ENVIRONMENT}"
if [[ -n "${AWS_ENVIRONMENT}" ]]; then
  params="${params} -param:environment=${AWS_ENVIRONMENT}"
fi

echo "[INPUT] metadata endpoint=${ECS_CONTAINER_METADATA_URI_V4}"
if [[ -n "${ECS_CONTAINER_METADATA_URI_V4}" ]]; then
  # https://docs.aws.amazon.com/AmazonECS/latest/userguide/task-metadata-endpoint-v4-fargate.html
  etl_batch_id=$(curl "${ECS_CONTAINER_METADATA_URI_V4}" | jq -r '.LogOptions["awslogs-stream"]' | sed 's~.*/~~')
# Intentionally commented out, LEFT IN FOR TESTING.  Normally we want a random ID
#elif [[ -f "/ecs-example.json" ]]; then
#  etl_batch_id=$(cat /ecs-example.json | jq -r '.LogOptions["awslogs-stream"]' | sed 's~.*/~~')
fi

if [[ "$etl_batch_id" -eq "" ]]; then
  etl_batch_id=$(cat /proc/sys/kernel/random/uuid)
fi
echo "[INPUT] etl_batch_id=${etl_batch_id}"

params="${params} -param:etl_batch_id=${etl_batch_id}"

verify_input_file_exists() {
  full_input_file="${INPUT_PATH}/${INPUT_FILE}"
  if [[ ! -f $full_input_file ]]; then
    echo "Expecting file ${full_input_file} to exist, but it does not."
    exit 1
  fi
}

download_file() {
  if [[ -n "${INPUT_FILE}" ]]; then # if the environment variable is not zero length...
    echo "[INPUT] INPUT_FILE=${INPUT_FILE}"
    params="${params} -param:input_file=${INPUT_FILE}"

  elif [[ -n "${S3_KEY}" ]]; then # if the environment variable is not zero length...
    echo "[INPUT] INPUT_FILE environment variable is blank. Setting the value to the filename parsed from environment variable S3_KEY"
    parsed_filename=$(echo $S3_KEY | sed 's~^.*\/~~')
    echo "[INPUT] INPUT_FILE=${parsed_filename}"
    params="${params} -param:input_file=${parsed_filename}"
    export INPUT_FILE="${parsed_filename}"

  else
    echo "Both environment variables INPUT_FILE and S3_KEY seem to be zero length. Cannot determine input filename."
    exit 1
  fi

  if [[ -n "${S3_BUCKET}" && -n "${S3_KEY}" ]]; then
    echo "Fetching input file from S3"
    /aws-s3-download.sh
  else
    echo "Not downloading from S3."
  fi

  verify_input_file_exists
}

check_for_input() {
  echo "[INPUT] INPUT_TYPE=${INPUT_TYPE}" # expected values: none, file, data
  input_data_parameter=""
  case "${INPUT_TYPE}" in
    none) # no need to download a file
      echo "No input is required. Skipping input check step."
      ;;

    data) # Input data is required!
      echo "[INPUT] INPUT_DATA=${INPUT_DATA}"
      if [[ -n "${INPUT_DATA}" ]]; then
        # We are not storing ${INPUT_DATA} in ${param} because it can contain spaces which will cause an issue when
        # passing the entire ${param} to kitchen.sh
        input_data_parameter="-param:input_data=${INPUT_DATA}"
      else
        echo "Cannot parse INPUT_DATA. When INPUT_TYPE is data, INPUT_DATA cannot be zero length"
        exit 1
      fi
      ;;

    file) # a file is required!
      download_file
      ;;

    *)
      echo "ERROR: Expected to find an environment variable named INPUT_TYPE with a value of 'none', 'data' or 'file' but another value was detected."
      exit 1
      ;;
  esac
}

run_pan() {
  echo ./pan.sh -file /jobs/$@
  pan.sh -file /jobs/$@
}

run_kitchen() {
  # we purposefully do not echo the 'params' variable because it can contain a password.
  # script output already shows non sensitive parameter values that are passed in.
  echo ./kitchen.sh -rep=PentahoFileRepository -level=Detailed -job=$@  "||" /aws-s3-upload-failure-json.sh "kitchen.sh exited with code = ???" "${etl_batch_id}" "${AWS_ENVIRONMENT}"
  # we want "params" to split / expand, so ignore the shellcheck
  # shellcheck disable=SC2086

  kitchen.sh -rep=PentahoFileRepository -level=Detailed ${params} "${input_data_parameter}" -job=$@ || /aws-s3-upload-failure-json.sh "kitchen.sh exited with code = ${?}" "${etl_batch_id}" "${AWS_ENVIRONMENT}"
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
  check_for_input
  run_pan "$@"
  ;;
j)
  shift 1
  check_for_input
  run_kitchen "$@"
  ;;
*)
  exec "$@"
  ;;
esac
