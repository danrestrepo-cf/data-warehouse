#!/usr/bin/env bash

project_name=edw
docker-compose --project-name ${project_name} -f docker-compose.yml down
