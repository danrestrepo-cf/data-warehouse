#!/usr/bin/env bash

# this will remove any docker images that have this string on the line when runing 'docker images' commanmd
image_tag="edw"

echo 'starting...'
echo "bringing containers down..."
./docker-down.sh

echo "removing image(s)..."
docker rmi $( docker images | grep ${image_tag}  | tr -s ' ' | cut -d ' ' -f 3)

echo "building pentaho image..."
./build-pentaho.sh

echo "building etl image based on pentaho image..."
./build-etl.sh

echo "bringing containers up..."
./docker-up.sh

echo 'done!'
