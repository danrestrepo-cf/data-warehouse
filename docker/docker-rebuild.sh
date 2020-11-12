#!/usr/bin/env bash

echo 'starting...'

echo "bringing containers down..."
./docker-down.sh

echo "removing image(s)..."
docker image rm -f edw/etl
docker image rm -f edw/pentaho

echo "building pentaho image..."
./build-pentaho.sh

echo "building etl image based on pentaho image..."
./build-etl.sh

echo "bringing containers up..."
./docker-up.sh

echo 'done!'
