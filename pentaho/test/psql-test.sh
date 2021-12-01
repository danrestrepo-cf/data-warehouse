#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1

#set the script to fail on any errors
set -e
if [ "$#" -lt 3 ]; then
  echo "Usage: ./psql-test.sh [database] [testpath] ... [psql arguments]"
  exit 1
fi

jenkins=${JENKINS_ENVIRONMENT:-false}

image="postgres:11"
if [ $jenkins = "true" ]; then
  image="188213074036.dkr.ecr.us-east-1.amazonaws.com/lura/dev-postgres:11"
fi

database=$1
testpath=$2

project_name=edw
docker run -i \
  --network ${project_name}_default \
  -e PGPASSWORD=testonly \
  -v $(pwd)/$testpath:/input \
  --rm ${image} psql -U postgres "postgresql://${project_name}_database_1:5432/$database" ${@:3}
