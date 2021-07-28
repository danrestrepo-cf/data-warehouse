#!/usr/bin/env bash

export MSYS_NO_PATHCONV=1

# we change directory within this script, so need the absolute path for relative references
path_to_script="$(pwd)/$(dirname "$0")"

# docker-compose does not like absolute paths on windows (git bash), so we reference it with a relative path
# it is important to never call this in a test directory, just between tests
relative_docker_dir="$(dirname "$0")/../../docker"
# absolute path to docker, used to trigger docker itself which isn't so picky
absolute_test_dir="$(pwd)/../../docker/pentaho"
# absolute path to metadata unit tests
absolute_metadata_test_dir="$(pwd)/../../scripts/edw-metadata-unit-tests"

#set the script to fail on any errors
set -e

#
# regex explanation
# -----------------------------
# ' testing'  - looks for lines that the test.sh script output. Example line: "Now testing SP8.2"
# ' Start='          - looks for the last line output by Kettle/Pan that contains the start and end times of the job.
# ' E=[1-9]'  - looks for steps that contain >0 errors.

# set default grep statement
grep_statement=" testing.*\| Start=.*\| Finished with errors.*\| E=[1-9].*"

# variable to store failed unit test runs
failed_unit_tests=""

# function to execute a pentaho transformation/job via test.sh
function execute_test() {
  # set current working directory to the folder with test.sh in it
  echo "Command for manual execution:  ${absolute_test_dir}/test.sh test \"$1\" \"$2\" \"$3\" \"$4\" \"$5\"
   | grep \"$grep_statement\""
  set +e
  results=$(${absolute_test_dir}/test.sh test "$1" "$2" "$3" "$4" "$5")
  # store test.sh exit code for evaluation
  unit_test_exit_code=$?
  if [[ $unit_test_exit_code != 0 ]]; then
    # store unit test name and (if applicable) test case that exited with non-zero code
    failed_unit_tests="${failed_unit_tests}$(realpath --relative-to $path_to_script $(pwd)) Pentaho exit code: $unit_test_exit_code"$'\n'
    echo $results
    echo "test.sh FAILED!!!"
  fi
  echo "$results" | grep -o "$grep_statement" # need to quote $results so work splitting doesn't occur
  set -e
  echo " "
}

# function to print usage details to the user/output device
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

# function to use command line supplied regex with grep or use default value
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
  ${relative_docker_dir}/docker-down.sh
  ${relative_docker_dir}/docker-up.sh
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
  expected_output="$1"
  actual_output="$2"
  diff_output="$3"
  test_case_diff_results=$(diff --strip-trailing-cr "$expected_output" "$actual_output" || true)
  if [[ $test_case_diff_results =~ .+ ]]; then
    echo $test_case_diff_results > "$diff_output"
    failed_unit_tests="${failed_unit_tests}$(realpath --relative-to $path_to_script $(pwd)) generated an unexpected result."$'\n'
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
    cd ${dir}
    echo "Now testing ${dir}" # indicate which test case is being run
    # run test setup SQL against the source database
    source_setup_results=$(${path_to_script}/psql-test.sh ${source_db} . -f /input/test_case_source_setup.sql)
    # run test setup SQL against the target database
    target_setup_results=$(${path_to_script}/psql-test.sh ${target_db} . -f /input/test_case_target_setup.sql)
    # run MDI configuration
    execute_test "$process_name" "$mdi_database_username" "$mdi_controller_path" "$input_type" "$filename"
    # run SQL export from target table to actual output file
    output_setup_results=$(${path_to_script}/psql-test.sh ${target_db} . -f /input/test_case_output_setup.sql)
    # run a diff between actual output and expected output files
    output_file_diff "expected_output.csv" "actual_output.csv" "test_diff_output.diff"
    cd -
  done
}

# function to run an EDW metadata test case
function execute_edw_metadata_unit_test() {
  test_to_run="$1"
  echo "Now running $test_to_run..."
  metadata_unit_test_result=$(python edw-metadata-unit-test-runner.py "$test_to_run")
  if [[ -n $metadata_unit_test_result ]]; then
    failed_unit_tests="${failed_unit_tests} $metadata_unit_test_result"$'\n'
  fi
}

# function to prompt the user whether to continue with unit test runner in the event of EDW metadata unit test failure
# this is constructed as a function to allow the script to continue if no user input is provided in the timeout window
function metadata_unit_test_fail_break {
  set +e
  echo "Proceed with remaining unit tests? [y/n]"
  proceed=""
  read -r -n1 -t 30 proceed
  echo
  if [[ $proceed == "y" ]]; then
    echo "Proceeding with remaining unit tests..."
  elif [[ $proceed == "n" ]]; then
    echo "Exiting unit test runner..."
    exit 1
  elif [[ $proceed == "" ]]; then
    echo "Proceeding with remaining unit tests..."
  else
    echo "Invalid input. Exiting unit test runner..."
    exit 1
  fi
  set -e
}

${relative_docker_dir}/docker-up.sh

# Run EDW metadata unit tests
cd ${absolute_metadata_test_dir}

echo "Proceeding with EDW metadata unit tests..."
execute_edw_metadata_unit_test "edw_table_definition_test_1"
execute_edw_metadata_unit_test "edw_table_definition_test_2"
execute_edw_metadata_unit_test "edw_field_definition_test_1"
execute_edw_metadata_unit_test "edw_field_definition_test_2"
execute_edw_metadata_unit_test "process_test_1"
execute_edw_metadata_unit_test "process_test_2"
execute_edw_metadata_unit_test "process_test_3"
execute_edw_metadata_unit_test "csv_file_input_step_test_1"
execute_edw_metadata_unit_test "csv_file_input_field_test_1"
execute_edw_metadata_unit_test "microsoft_excel_input_step_test_1"
execute_edw_metadata_unit_test "microsoft_excel_input_field_test_1"
execute_edw_metadata_unit_test "table_input_step_test_1"
execute_edw_metadata_unit_test "table_input_step_test_2"
execute_edw_metadata_unit_test "table_output_step_test_1"
execute_edw_metadata_unit_test "table_output_step_test_2"
execute_edw_metadata_unit_test "table_output_step_test_3"
execute_edw_metadata_unit_test "table_output_field_test_1"
execute_edw_metadata_unit_test "table_output_field_test_2"
execute_edw_metadata_unit_test "table_output_field_test_3"
execute_edw_metadata_unit_test "insert_update_step_test_1"
execute_edw_metadata_unit_test "insert_update_step_test_2"
execute_edw_metadata_unit_test "insert_update_step_test_3"
execute_edw_metadata_unit_test "insert_update_step_test_4"
execute_edw_metadata_unit_test "insert_update_key_test_1"
execute_edw_metadata_unit_test "insert_update_field_test_1"
execute_edw_metadata_unit_test "insert_update_field_test_2"
execute_edw_metadata_unit_test "delete_step_test_1"
execute_edw_metadata_unit_test "delete_key_test_1"
execute_edw_metadata_unit_test "json_output_field_test_1"
execute_edw_metadata_unit_test "json_output_field_test_2"

# If any EDW metadata unit tests fail, print the failures and ask the user whether to proceed with remaining unit tests
# Otherwise, proceed with remaining unit tests
if [[ -n $failed_unit_tests ]]; then
  failed_unit_tests="EDW metadata unit tests FAILED:"$'\n'"${failed_unit_tests}"
  echo
  echo "$failed_unit_tests"
  metadata_unit_test_fail_break
else
  echo "EDW metadata unit tests succeeded."
  echo "Proceeding with remaining unit tests..."
fi

cd "$(pwd)/../../pentaho/test"

# Non MDI Tests ##########################################################################
process_name="SP6"
database_username="encompass_sp6"
sp6_job_path="encompass/import/SP6/full_encompass_etl"
echo Now testing ${process_name}
cd ${process_name}
execute_test ${process_name} ${database_username} ${sp6_job_path} "file" "Encompass.csv"
cd -

# MDI Test Cases #########################################################################
database_username="mditest"
execute_mdi_test_cases "SP-0.1" ${database_username} "file" "input.csv" "ingress" "ingress"
execute_mdi_test_cases "SP-0.2" ${database_username} "file" "input.xlsx" "ingress" "ingress"
execute_mdi_test_cases "SP-0.3" ${database_username} "none" "" "ingress" "ingress"
execute_mdi_test_cases "SP-0.4" ${database_username} "none" "" "ingress" "ingress"
execute_mdi_test_cases "SP-0.5" ${database_username} "none" "" "ingress" "ingress"
execute_mdi_test_cases "SP-0.6" ${database_username} "none" "" "ingress" "ingress"

# DMI Tests ##############################################################################
database_username="dmi"
# DMI NMLS Call Report - State	# DMI NMLS Call Report - State (curl "https://api.mockaroo.com/api/faa92490?count=1&key=8ff5d150" > "dmi-V35-state.csv")
execute_mdi_test_cases "SP8.1" ${database_username} "file" "test_case_source_file.csv" "ingress" "ingress"
execute_mdi_test_cases "SP8.2" ${database_username} "none" "" "ingress" "staging"

# DMI NMLS Call Report - National	# DMI NMLS Call Report - National (curl "https://api.mockaroo.com/api/9011edb0?count=1&key=8ff5d150" > "dmi-V35-national.csv")
execute_mdi_test_cases "SP9.1" ${database_username} "file" "test_case_source_file.csv" "ingress" "ingress"
execute_mdi_test_cases "SP9.2" ${database_username} "none" "" "ingress" "staging"

# DMI NMLS Call Report - s540a	# DMI NMLS Call Report - s540a (curl "https://api.mockaroo.com/api/3d9794e0?count=1&key=8ff5d150" > "dmi-V35-s540a.csv")
execute_mdi_test_cases "SP10.1" ${database_username} "file" "test_case_source_file.csv" "ingress" "ingress"
execute_mdi_test_cases "SP10.2" ${database_username} "none" "" "ingress" "staging"

# Print overall unit test statuses and test case diff statuses
if [[ -z $failed_unit_tests ]]; then
  echo "Unit tests SUCCESSFUL."
  exit 0
else
  echo "One or more unit tests encountered a failure, or generated an output that differs from its expected result."
  echo "Refer to the list below for more information:"
  echo "$failed_unit_tests"
  echo
  echo "Unit test FAILURE."
  exit 1
fi
