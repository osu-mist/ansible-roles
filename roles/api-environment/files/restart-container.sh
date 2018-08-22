#!/bin/sh
# restart-container.sh - restarts/starts container
# Usually called remotely by jenkins
# Usage: restart-container.sh API-NAME

set -eu

api_name=$1

if [[ $(docker inspect -f {{.State.Running}} $api_name) ]]; then
  docker restart $api_name
else
  docker start $api_name
fi
