#!/usr/bin/env bash

# Sets script to fail if any command fails.
set -e

echo 'Starting...'

./docker-down.sh

echo "Removing image(s)..."
docker image rm -f edw/etl
docker image rm -f edw/pentaho

echo "Building pentaho image..."
./build-pentaho.sh

echo "Building etl image based on pentaho image..."
./build-etl.sh

./docker-up.sh

echo '... Finished rebuilding images!'
