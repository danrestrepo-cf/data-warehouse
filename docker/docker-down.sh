#!/usr/bin/env bash

path_to_script=$(dirname "$0")
base_project_name=edw

jenkins=${JENKINS_ENVIRONMENT:-false}

project_name=edw
function run_compose_file {
  migration_category=$1
  project_name=$2

  override=""
  if [ $jenkins = "true" ]; then
    override="-f ${path_to_script}/docker-compose-${migration_category}-ci.yml"
  fi

  docker-compose --project-name ${project_name} -f ${path_to_script}/docker-compose-${migration_category}.yml ${override} down
}

# take down the application in the opposite way we created it
for migration_category in permissions ddl schemas; do
  run_compose_file ${migration_category} ${base_project_name}_${migration_category}
done

run_compose_file baseline ${base_project_name}
