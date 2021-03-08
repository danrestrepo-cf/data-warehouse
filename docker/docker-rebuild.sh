#!/usr/bin/env bash

path_to_script=$(dirname "$0")

# Sets script to fail if any command fails.
set -e

echo 'Starting...'

${path_to_script}/docker-down.sh

echo "Removing image(s)..."
docker image rm -f edw/etl
docker image rm -f edw/pentaho

echo "Building pentaho image..."
${path_to_script}/build-pentaho.sh

echo "Building etl image based on pentaho image..."
${path_to_script}/build-etl.sh

${path_to_script}/docker-up.sh

echo '... Finished rebuilding images!'
