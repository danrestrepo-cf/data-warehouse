#!/usr/bin/env bash

path_to_script=$(dirname "$0")
base_project_name=edw

jenkins=${JENKINS_ENVIRONMENT:-false}

function run_compose_file {
  migration_category=$1
  project_name=$2

  echo -e "== Applying ${migration_category} migrations"

  waitFor=()

  override=""
  if [ $jenkins = "true" ]; then
    override="-f ${path_to_script}/docker-compose-${migration_category}-ci.yml"
  fi

  # baseline is the only migration category that does not build ingress, staging, and config flyway services, so the
  # construction of its waitFor command is handled separately
  if [ $migration_category != "baseline" ]; then
    for database in ingress staging config; do
      waitFor+=("${project_name}_flyway-${database}_1")
    done
  else
      waitFor+=("${project_name}_flyway-roles_1")
  fi

  docker-compose --project-name ${project_name} -f ${path_to_script}/docker-compose-${migration_category}.yml ${override} up --detach

  echo -e "== Waiting for ${migration_category} migrations"
  for container in "${waitFor[@]}"; do
    echo "Waiting for $container"

    # docker wait returns a success status, but echos the actual status, so capture that and compare
    # i.e., if the container fails then it'll echo a "1" but its return status is still 0
    result=$(docker wait ${container})
    if [ $result != "0" ]; then
      echo "====== FAILURE in ${container} ======="
      docker logs ${container}
      echo "====== FAILURE in ${container} ======="
    fi
  done
}

# run initial compose file with project name set to the base project name
run_compose_file baseline ${base_project_name}

# run all other compose files with the project name set to the base project suffixed with the migration category
for migration_category in schemas ddl permissions; do
  run_compose_file ${migration_category} ${base_project_name}_${migration_category}
done
