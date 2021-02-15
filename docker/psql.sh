#!/usr/bin/env bash

# display script usage
function print_usage() {
  echo " "
  echo "${script_filename} -- script usage"
  echo "Usage: ${script_filename} [database name] [database username]"
  echo " "
  echo "The first parameter is the database name to connect to (like ingress, config, staging, etc)."
  echo "The second parameter is the name of the user used to connect to the database. If the second parameter is not provided it defaults to the value '${default_db_username}'."
}

# execute psql docker image using db_username, project_name, and database variables
function run_docker() {
  echo "Logging into PostgreSQL with username: ${db_username} and database: ${database}"
  docker run -it \
    --network ${project_name}_default \
    --rm postgres:11 psql -U ${db_username} "postgresql://${project_name}_database_1:5432/${database}"
}

# set variable defaults
project_name=edw
default_db_username=postgres
database="${1}" # first parameter is always the database we connect to
script_filename=${0##*/}

# validate input parameters
case "$#" in
  1) # if only one parameter then use the default username
    db_username="${default_db_username}"
    run_docker
    ;;
  2) # if two parameters then use the 2nd parameter as the username
    db_username="${2}"
    run_docker
    ;;
  *)
    echo "ERROR: Could not understand input parameters. ${script_filename} expects 1 or 2 parameters where the first parameter is the name of the database to connect (required) and the second is the name of the user to use to connect to the database (optional). Found ${#} parameters total were provided."
    echo "Displaying script usage:"
    print_usage
    exit 1
    ;;
esac
