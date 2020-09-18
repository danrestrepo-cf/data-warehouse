#!/usr/bin/env bash

database=$1

project_name=edw
docker run -it \
  --network ${project_name}_default \
  --rm postgres:11 psql -U postgres "postgresql://${project_name}_database_1:5432/$database"
