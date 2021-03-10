#!/usr/bin/env bash

path_to_script=$(dirname "$0")

echo -e "= Creating Infrastructure..."
project_name=edw
docker-compose --project-name ${project_name} -f ${path_to_script}/docker-compose.yml up --detach

# We need the beforeMigrate files present for docker, trying to mount them as separate volumes results
# in unpredictable migrations
waitFor=""
for database in ingress staging config; do
  cp ${path_to_script}/database/baseline/${database}/beforeMigrate.sql ${path_to_script}/database/migrations/${database}/
  waitFor="${waitFor} ${project_name}_flyway-${database}_1"
done

# wait for the migrations to complete before applying permissions
echo -e "== Waiting for migrations"
docker wait ${waitFor}
echo -e "== Applying permissions"

docker-compose --project-name ${project_name}_permissions -f ${path_to_script}/docker-compose-roles.yml up --detach
waitFor=""
for database in ingress staging config; do
  waitFor="${waitFor} ${project_name}_permissions_flyway-${database}-permissions_1"
done
echo -e "== Waiting for permissions"
docker wait ${waitFor}

echo -e "= Finished infrastructure."
