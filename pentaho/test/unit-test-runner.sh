#!/usr/bin/env bash

test_dir=$(dirname "$0")
echo ${test_dir}
#if [[ "$machine" == "Win" ]]; then
# set git bash so it does not convert paths using POSIX standard
export MSYS_NO_PATHCONV=1
#fi

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
  cd -
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

function docker_reset() {
  cd ${test_dir}/../../docker/
  ./docker-down.sh
  ./docker-up.sh
  cd -
}

function execute_mdi_test() {
  mdi_controller_path="mdi/controller"
  process_name="$1"
  mdi_database_username="$2"
  input_type=$3
  filename="$4"
  echo "Now testing ${process_name}"
  execute_test "$process_name" "$mdi_database_username" "$mdi_controller_path" "$input_type" "$filename"
}

function output_file_diff() {
  diff_results=$(diff --strip-trailing-cr ${1} ${2} || true)
  if [[ $diff_results =~ .+ ]]; then
    echo $diff_results > $3
  fi
}

function execute_mdi_test_cases() {
  mdi_controller_path="mdi/controller"
  process_name="$1"
  mdi_database_username="$2"
  input_type=$3
  filename="$4"
  diff_results=""
  for dir in ${process_name}/*; do
    echo "Now testing ${dir}"
    # This line needs code to remove all .diff files 
    truncate -s 0 ${dir}/actual_output.csv
    input_setup_results=$(../../pentaho/test/psql-test.sh ingress ${dir} -f /input/test_case_input_setup.sql)
    execute_test "$process_name" "$mdi_database_username" "$mdi_controller_path" "$input_type" "$filename"
    output_setup_results=$(../../pentaho/test/psql-test.sh ingress ${dir} -f /input/test_case_output_setup.sql)
    # diff --strip-trailing-cr ${dir}/expected_output.csv ${dir}/actual_output.csv || echo ${dir} has differences above
#    if output_file_diff "${dir}/expected_output.csv" "${dir}/actual_output.csv" > /dev/null
#    then
#      echo "No difference detected; test case passed"
#    else
#      # output_file_diff ${dir}/expected_output.csv ${dir}/actual_output.csv
#      echo "Difference detected; test case failed"
#      diff_results=$diff_results${dir}
#      diff_results=$diff_results$'\n'
#    fi
    output_file_diff "${dir}/expected_output.csv" "${dir}/actual_output.csv"  "${dir}/test_diff_output.diff"
    docker_reset
  done
#  if [[ $diff_results != "" ]]
#  then
#    echo $'\n'"One or more test cases failed:"
#    echo "$diff_results"
#  fi
}

# Non MDI Tests ##########################################################################
#process_name="SP6"
#database_username="encompass_sp6"
#sp6_job_path="encompass/import/SP6/full_encompass_etl"
#echo Now testing ${process_name}
#execute_test ${process_name} ${database_username} ${sp6_job_path} "file" "Encompass.csv"

# MDI Tests ##############################################################################
#database_username="mditest"
# MDI Checks
#execute_mdi_test "SP-0.1"  ${database_username} "file" "input.csv"   # test performer_csv_to_table.ktr
#execute_mdi_test "SP-0.2"  ${database_username} "file" "input.xlsx" # test performer_excel_to_table.ktr

# MDI Test Cases #########################################################################
database_username="mditest"
# MDI Checks for SP-0.3 and SP-0.4
execute_mdi_test_cases "SP-0.3" ${database_username} "none" ""
# ../../docker/docker-down.sh
# ../../docker/docker-up.sh

# DMI Tests ##############################################################################
#database_username="dmi"
# DMI NMLS Call Report - State	# DMI NMLS Call Report - State (curl "https://api.mockaroo.com/api/faa92490?count=1000&key=8ff5d150" > "dmi-V35-state.csv")
#execute_mdi_test "SP8.1"  ${database_username} "file" "dmi-V35-state.csv"
#execute_mdi_test "SP8.2"  ${database_username} "none" ""

# DMI NMLS Call Report - National	# DMI NMLS Call Report - National (curl "https://api.mockaroo.com/api/9011edb0?count=1000&key=8ff5d150" > "dmi-V35-national.csv")
#execute_mdi_test "SP9.1"  ${database_username} "file" "dmi-V35-national.csv"
#execute_mdi_test "SP9.2"  ${database_username} "none" ""

# DMI NMLS Call Report - s540a	# DMI NMLS Call Report - s540a (curl "https://api.mockaroo.com/api/3d9794e0?count=1000&key=8ff5d150" > "dmi-V35-s540a.csv")
#execute_mdi_test "SP10.1" ${database_username} "file" "dmi-V35-s540a.csv"
#execute_mdi_test "SP10.2" ${database_username} "none" ""

find . -name '*.diff'