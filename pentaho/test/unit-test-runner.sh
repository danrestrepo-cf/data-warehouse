#!/usr/bin/env bash

#set the script to fail on any errors
set -e

# set default grep statement
grep_statement=" testing\| Start=\| Finished with errors"

function execute_test()
{
  # set current working directory to the folder with test.sh in it
  cd "$(pwd)/../../docker/pentaho/"
  echo "Command for manual execution:  $(pwd)/../../docker/pentaho/test.sh test \"$1\" \"$2\" \"$3\" | grep \"$grep_statement\""
  ./test.sh test "$1" "$2" "$3" | grep "$grep_statement"
  echo " "
}

function print_usage()
{
  # set script name
  script_filename=${0##*/}
  echo "${script_filename} -- script usage"
  echo " "
  echo " Use this script to configure and execute unit tests for Pentaho."
  echo "    Execute all tests with minimal output example: ./${script_filename}"
  echo "    Execute all tests with ALL output example: ./${script_filename} \".\""
  echo "    Execute all tests with custom grep example: ./${script_filename} \"ERROR\|testing\[Tt]est\""
  echo "    Display this usage example: ./${script_filename} -h"

}

function generate_grep_phrase()
{
  if [[ "$1" != "" ]]; then # if one parameter use that in the grep statement
      grep_statement=$1
      echo "Using supplied grep statement: \"$grep_statement\""

  elif [[ "$1" == "" ]]; then # if no parameters, use the default grep statement
      echo "Using default grep statement: \"$grep_statement\""

  else # the input isn't understood, show the usage statement
        echo "Unable to understand input parameters."
        print_usage
        exit 1
  fi
}


# print usage statement
if [[ $1 == "-h" ]]; then
  print_usage
  exit 0

  else
    generate_grep_phrase "$1"
fi


# Non MDI Tests ##########################################################################
process_name="SP6"
sp6_job_path="encompass/import/SP6/full_encompass_etl"
echo Now testing ${process_name}
execute_test ${process_name} "Encompass.csv" ${sp6_job_path}


# set MDI defaults
mdi_controller_path="mdi/controller"

# MDI Tests ##############################################################################
process_name="SP8.1"
echo Now testing ${process_name}
execute_test ${process_name} "dmi-V35-state.csv" ${mdi_controller_path}
##########################################################################################
process_name="SP9.1"
echo Now testing ${process_name}
execute_test ${process_name} "dmi-V35-national.csv" ${mdi_controller_path}
##########################################################################################
process_name="SP10.1"
echo Now testing ${process_name}
execute_test ${process_name} "dmi-V35.xls" ${mdi_controller_path}
