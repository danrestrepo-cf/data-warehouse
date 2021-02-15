#!/usr/bin/env bash

# display script usage
function print_usage() {
  script_filename=${0##*/}
  echo "${script_filename} -- script usage"
  echo " "
  echo " Bash Mode - run docker and launch bash instead of executing a Pentaho process."
  echo "    Usage: ${script_filename} bash"
  echo "    Example: ./${script_filename} bash"
  echo " "
}

# execute psql docker image using db_username, project_name, and database variables
function run_docker() {
  echo_connection_details
  docker run -it \
    --network ${project_name}_default \
    --rm postgres:11 psql -U ${db_username} "postgresql://${project_name}_database_1:5432/${database}"
}

function echo_connection_details() {
  echo "Logging into PostgreSQL with username: ${db_username} and database: ${database}"
}

# set variable defaults
project_name=edw
default_db_username=postgres
database="${1}" # first parameter is always the database we connect to

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
    echo "ERROR: Could not understand input parameters. ${script_filename} expects 1 parameter where the first parameter is the name of the database to connect to but found ${#} parameters total."
    echo "Displaying script usage:"
    print_usage
    exit 1
    ;;
esac
