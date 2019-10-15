#!/bin/bash
set -e

unhealthy_containers=$(docker container ls --format "{{.ID}} {{.Names}}" --filter health=unhealthy)

if [ -n "$unhealthy_containers" ]; then
  echo -e "Found unhealthy containers:\n
ID           NAME
$unhealthy_containers\n"
  exit 1
else
  echo "No unhealthy containers found"
fi

