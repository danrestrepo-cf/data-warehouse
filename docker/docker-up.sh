#!/usr/bin/env bash

echo -e "= Creating Infrastructure..."
project_name=edw
docker-compose --project-name ${project_name} -f docker-compose.yml up --detach

echo -e "= Finished infrastructure."
