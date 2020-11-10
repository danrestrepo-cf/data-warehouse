#!/usr/bin/env bash

./docker-down.sh
docker system prune -a
docker system prune --volumes -a
./build-pentaho.sh
.build-etl.sh
./docker-up.sh

echo 'done! try using command: cd pentaho;./test-mdi-win.sh SP8.1 dmi-V35-state.csv 241pm'