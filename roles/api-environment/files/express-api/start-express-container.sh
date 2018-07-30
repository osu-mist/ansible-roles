#!/bin/sh
# start-express-container.sh - starts an express api with docker
# usually called remotely by jenkins

# usage: start-express-container.sh API-NAME

set -eu

api_name=$1
api_path=/apis/apis/$api_name
env=/apis/env/$api_name.env

cd $api_path

# Stop and destroy container if it's already running
if [[ "$(docker ps -aq -f name=$api_name)" ]]; then
    echo "Stop existing container $(docker stop $api_name)"
    echo "Remove existing container $(docker rm "$api_name")"

    # Sometimes docker will still think a container exists after doing "docker rm"
    # Pause the script for a few seconds before creating the container again
    until [[ ! "$(docker ps -aq -f name=$api_name)" ]]; do
        sleep 1
    done
fi

# Remove image if it already exists
image_id=$(docker images -q $api_name)
if [[ $image_id ]]; then
  echo "Remove existing image $image_id"
  docker rmi $image_id --force
fi

rm `find $api_name-*.tar | sort -r | awk 'NR>3'` # only keep the 3 of the most recent artifacts
archive=$(find $api_name-*.tar | sort | tail -1)

re="$api_name-([0-9]+).tar"

if [[ $archive =~ $re ]]; then
  tag=${BASH_REMATCH[1]}
fi

docker import $archive $api_name:$tag

docker run -d \
           --workdir /usr/src/$api_name \
           --env-file $env \
           --volume /apis/keytool_files:/usr/src/$api_name/keytool_files \
           --volume $api_path/logs:/usr/src/$api_name/logs \
           --network host \
           --health-cmd='curl -k -fsS --user $USER:$PASSWD https://localhost:$PORT/api/v1' \
           --name $api_name \
           $api_name:$tag \
           gulp run

if [[ ! $(docker ps -q -f name=$api_name) ]]; then
   echo "ERROR: Container not running"
   exit 1
fi
