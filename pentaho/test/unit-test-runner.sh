#!/usr/bin/env bash

test_dir=$(dirname "$0")
export MSYS_NO_PATHCONV=1

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

# function to reset docker between MDI test case runs
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

# function to detect, print, and remove previous diff files
function process_previous_diffs() {
  process_name="$1"
  echo "Now checking for diff files from previous runs..."
  previous_diff_results=$(find ./"$1"/ -name 'test_diff_output.diff' -type f) # print .diff files from previous runs
  if [[ -n "$previous_diff_results" ]]; then
    echo "Removing previous diff results:"
    echo "$previous_diff_results"
    find ./"$1"/ -name 'test_diff_output.diff' -type f -delete
  else
    echo "No previous diff files detected"
  fi
}

# function to output a diff between expected output and actual output for MDI test cases
function output_file_diff() {
  test_case_diff_results=$(diff --strip-trailing-cr ${1} ${2} || true)
  if [[ $test_case_diff_results =~ .+ ]]; then
    echo $test_case_diff_results > $3
  fi
}

# function to run through MDI test cases
function execute_mdi_test_cases() {
  mdi_controller_path="mdi/controller"
  process_name="$1"
  mdi_database_username="$2"
  input_type=$3
  filename="$4"
  source_db="$5"
  target_db="$6"
  process_previous_diffs "$process_name"
  echo
  echo "Proceeding with ${process_name} test cases"
  for dir in ${process_name}/*; do
    echo "Now resetting Docker..."
    docker_reset # reset docker
    echo "Now testing ${dir}" # indicate which test case is being run
    # run test setup SQL against the source database
    source_setup_results=$(../../pentaho/test/psql-test.sh ${source_db} ${dir} -f /input/test_case_source_setup.sql)
    # run test setup SQL against the target database
    target_setup_results=$(../../pentaho/test/psql-test.sh ${target_db} ${dir} -f /input/test_case_target_setup.sql)
    # run MDI configuration
    execute_test "$process_name" "$mdi_database_username" "$mdi_controller_path" "$input_type" "$filename"
    # run SQL export from target table to actual output file
    output_setup_results=$(../../pentaho/test/psql-test.sh ${target_db} ${dir} -f /input/test_case_output_setup.sql)
    # run a diff between actual output and expected output files
    output_file_diff "${dir}/expected_output.csv" "${dir}/actual_output.csv"  "${dir}/test_diff_output.diff"
  done
}

# Non MDI Tests ##########################################################################
process_name="SP6"
database_username="encompass_sp6"
sp6_job_path="encompass/import/SP6/full_encompass_etl"
echo Now testing ${process_name}
execute_test ${process_name} ${database_username} ${sp6_job_path} "file" "Encompass.csv"

# MDI Tests ##############################################################################
database_username="mditest"
# MDI Checks
execute_mdi_test "SP-0.1"  ${database_username} "file" "input.csv"   # test performer_csv_to_table.ktr
execute_mdi_test "SP-0.2"  ${database_username} "file" "input.xlsx" # test performer_excel_to_table.ktr

# MDI Test Cases #########################################################################
database_username="mditest"
# MDI Checks for SP-0.3 and SP-0.4
execute_mdi_test_cases "SP-0.3" ${database_username} "none" "" "ingress" "ingress"
execute_mdi_test_cases "SP-0.4" ${database_username} "none" "" "ingress" "ingress"

# DMI Tests ##############################################################################
database_username="dmi"
# DMI NMLS Call Report - State	# DMI NMLS Call Report - State (curl "https://api.mockaroo.com/api/faa92490?count=1000&key=8ff5d150" > "dmi-V35-state.csv")
execute_mdi_test "SP8.1"  ${database_username} "file" "dmi-V35-state.csv"
execute_mdi_test "SP8.2"  ${database_username} "none" ""

# DMI NMLS Call Report - National	# DMI NMLS Call Report - National (curl "https://api.mockaroo.com/api/9011edb0?count=1000&key=8ff5d150" > "dmi-V35-national.csv")
execute_mdi_test "SP9.1"  ${database_username} "file" "dmi-V35-national.csv"
execute_mdi_test "SP9.2"  ${database_username} "none" ""

# DMI NMLS Call Report - s540a	# DMI NMLS Call Report - s540a (curl "https://api.mockaroo.com/api/3d9794e0?count=1000&key=8ff5d150" > "dmi-V35-s540a.csv")
execute_mdi_test "SP10.1" ${database_username} "file" "dmi-V35-s540a.csv"
execute_mdi_test "SP10.2" ${database_username} "none" ""

# Print test case diff status(es)
diff_results=$(find . -name 'test_diff_output.diff') # using find, store any diff files in diff_results variable
if [[ -z "$diff_results" ]]; then # check diff_results variable to determine whether there were any diffs
  echo
  echo "No test case diffs were detected; all test cases have passed"
  exit 0
else
  echo
  echo "One or more test cases failed; refer to the following diff file(s) for more information:"
  echo "$diff_results"
  exit 1
fi