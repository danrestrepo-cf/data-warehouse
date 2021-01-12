#!/usr/bin/env bash

#set the script to fail on any errors
set -e


#
# regex explanation
# -----------------------------
# ' testing'  - looks for lines that the test.sh script output. Example line: "Now testing SP8.2"
# ' Start='          - looks for the last line output by Kettle/Pan that contains the start and end times of the job.
# ' E=[1-9]'  - looks for steps that contain >0 errors.

# set default grep statement
grep_statement=" testing\| Start=\| Finished with errors\| E=[1-9]"



function execute_test() {
  # set current working directory to the folder with test.sh in it
  cd "$(pwd)/../../docker/pentaho/"
  echo "Command for manual execution:  $(pwd)/../../docker/pentaho/test.sh test \"$1\" \"$2\" \"$3\" \"$4\" "$5" | grep \"$grep_statement\""
  ./test.sh test "$1" "$2" "$3" "$4" "$5" | grep "$grep_statement"
  echo " "
}

function print_usage() {
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

function generate_grep_phrase() {
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

function execute_mdi_test () {
  mdi_controller_path="mdi/controller"
  process_name="$1"
  mdi_database_username="$2"
  input_type=$3
  filename="$4"
  echo "Now testing ${process_name}"
  execute_test "$process_name" "$mdi_database_username" "$mdi_controller_path" "$input_type" "$filename"
}


# Non MDI Tests ##########################################################################
process_name="SP6"
database_username="encompass_SP6"
sp6_job_path="encompass/import/SP6/full_encompass_etl"
input_type="file"
echo Now testing ${process_name}
execute_test ${process_name} ${database_username} ${sp6_job_path} ${input_type} "Encompass.csv"
unset input_type

# MDI Tests ##############################################################################
database_username="dmi"
# DMI NMLS Call Report - State
execute_mdi_test "SP8.1"  ${database_username} "file" "dmi-V35-state.csv"
execute_mdi_test "SP8.2"  ${database_username} "none" ""

# DMI NMLS Call Report - National
execute_mdi_test "SP9.1"  ${database_username} "file" "dmi-V35-national.csv"
execute_mdi_test "SP9.2"  ${database_username} "none" ""

# DMI NMLS Call Report - s540a
execute_mdi_test "SP10.1" ${database_username} "file" "dmi-V35.xls"
execute_mdi_test "SP10.2" ${database_username} "none" ""
