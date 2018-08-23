#!/bin/sh
# restart-container.sh - restarts/starts container
# Usually called remotely by jenkins
# Usage: restart-container.sh API-NAME

set -eu

api_name=$1

if [[ $(docker inspect -f {{.State.Running}} $api_name) ]]; then
  echo "$api_name is running. Restarting container."
  docker restart $api_name
else
  echo "$api_name is not running. Starting container."
  docker start $api_name
fi
