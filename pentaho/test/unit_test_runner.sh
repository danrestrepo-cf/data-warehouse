#!/usr/bin/env bash

#set the script to fail on any errors
set -e

# set script defaults
mdi_controller_path="mdi/controller"

function execute_test()
{
  # set current working directory to the folder with test.sh in it
  cd "$(pwd)/../../docker/pentaho/"
  ./test.sh test "$1" "$2" "$3"
}

##########################################################################################
process_name="SP8.1"
echo Now testing ${process_name}
execute_test ${process_name} "dmi-V35-state.csv" ${mdi_controller_path}
##########################################################################################
process_name="SP9.1"
echo Now testing ${process_name}
execute_test ${process_name} "dmi-V35-national.csv" ${mdi_controller_path}

