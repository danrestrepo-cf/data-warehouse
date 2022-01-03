#!/usr/bin/env bash

set -e

path_to_script="$(dirname "$0")"

# set variable defaults
project_name=edw
default_db_username=postgres
database="${1}" # first parameter is always the database we connect to
script_filename=${0##*/}

# validate input parameters
case "$#" in
  1) # if only one parameter then use the default username
    db_username="${default_db_username}"
    ;;
  2) # if two parameters then use the 2nd parameter as the username
    db_username="${2}"
    ;;
  *)
    echo " "
    echo "Usage: ${script_filename} [database name] [database username]"
    echo "\t[database name] is the database name to connect to (like ingress, config, staging, etc)."
    echo "\t[database username] is the name of the user used to connect to the database. Defaults to the value '${default_db_username}'."
    exit 1
    ;;
esac

image="${POSTGRES_IMAGE:-postgres-13.4}"

jenkins=${JENKINS_ENVIRONMENT:-false}
if [ $jenkins = "true" ]; then
  ${path_to_script}/aws-ecr-login.sh 188213074036
fi

# execute psql docker image using db_username, project_name, and database variables
echo "Logging into PostgreSQL with username: ${db_username} and database: ${database}"
docker run -it \
  --network ${project_name}_default \
  --rm ${image} psql -U ${db_username} "postgresql://${project_name}_database_1:5432/${database}"
