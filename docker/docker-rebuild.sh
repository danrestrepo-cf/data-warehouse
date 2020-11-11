#!/usr/bin/env bash
echo 'starting...'

# replace prune with rm to remove a container
docker system prune -a
docker system prune --volumes -a
./build-pentaho.sh
./build-etl.sh
./docker-down.sh
./docker-up.sh

echo 'done!'
