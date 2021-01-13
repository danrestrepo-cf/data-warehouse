#!/usr/bin/env bash

echo -e "= Creating Infrastructure..."
project_name=edw
docker-compose --project-name ${project_name} -f docker-compose.yml up --detach

# We need the beforeMigrate files present for docker, trying to mount them as separate volumes results
# in unpredictable migrations
waitFor=""
for database in ingress staging config; do
  cp database/baseline/${database}/beforeMigrate.sql database/migrations/${database}/
  waitFor="${waitFor} ${project_name}_flyway-${database}_1"
done

# wait for the migrations to complete before applying permissions
echo -e "== Waiting for migrations"
docker wait ${waitFor}
echo -e "== Applying permissions"

docker-compose --project-name ${project_name}_permissions -f docker-compose-roles.yml up --detach

echo -e "= Finished infrastructure."
