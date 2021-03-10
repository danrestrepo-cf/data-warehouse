#!/usr/bin/env bash

path_to_script=$(dirname "$0")

docker build -f ${path_to_script}/etl.Dockerfile -t edw/etl ${path_to_script}/../pentaho/src
