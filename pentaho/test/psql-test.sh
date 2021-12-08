#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1

# we change directory within this script, so need the absolute path for relative references
path_to_script="$(dirname "$0")"

#set the script to fail on any errors
set -e
if [ "$#" -lt 3 ]; then
  echo "Usage: ./psql-test.sh [database] [testpath] ... [psql arguments]"
  exit 1
fi

image="${POSTGRES_IMAGE:-postgres:12}"

jenkins=${JENKINS_ENVIRONMENT:-false}
if [ $jenkins = "true" ]; then
  ${path_to_script}/../../aws-ecr-login.sh 188213074036
fi

database=$1
testpath=$2

project_name=edw
docker run -i \
  --network ${project_name}_default \
  -e PGPASSWORD=testonly \
  -v $(pwd)/$testpath:/input \
  --rm ${image} psql -U postgres "postgresql://${project_name}_database_1:5432/$database" ${@:3}
