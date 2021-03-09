#!/usr/bin/env bash

path_to_script=$(dirname "$0")

project_name=edw
docker-compose --project-name ${project_name}_permissions -f ${path_to_script}/docker-compose-roles.yml down
docker-compose --project-name ${project_name} -f ${path_to_script}/docker-compose.yml down
