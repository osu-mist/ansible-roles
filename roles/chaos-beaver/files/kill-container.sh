#!/bin/sh
# kill-container.sh - ungracefully stops a docker container
# Usage: kill-container.sh CONTAINER_NAME

set -eu

container_name=$1

docker kill $container_name
