#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1

#set the script to fail on any errors
set -e

database=$1
testpath=$2
# echo $(pwd)
# echo $testpath

project_name=edw
docker run -it \
  --network ${project_name}_default \
  -e PGPASSWORD=testonly \
  -v $(pwd)/$testpath:/input \
  --rm postgres:11 psql -U postgres "postgresql://${project_name}_database_1:5432/$database" ${@:3}
