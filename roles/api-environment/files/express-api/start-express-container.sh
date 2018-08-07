#!/bin/sh
# start-express-container.sh - starts an express api with docker
# usually called remotely by jenkins

# usage: start-express-container.sh API-NAME

set -eu

api_name=$1
artifact_tag=$2
api_path=/apis/apis/$api_name
env=/apis/env/$api_name.env

cd $api_path

# only keep the 3 of the most recent artifacts
total_artifacts=$(find -type f -name "$api_name-*.tar" | wc -l)
if [ $total_artifacts -gt 3 ]; then
  echo "Remove old artifacts from workspace."
  rm $(find $api_name-*.tar -printf "%T@ %p\n" | sort -n | head -$((total_artifacts - 3)) | cut -f2- -d" ")
fi

archive=$(find $api_name-*.tar -printf "%T@ %p\n" | sort | tail -1 | cut -f2- -d" ")

if [[ $archive != "$api_name-$artifact_tag.tar" ]]; then
  # Exit with non-zero code if artifact not found
  echo "ERROR: Artifact not found"
  exit 1
fi

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

docker import $archive $api_name:$artifact_tag

docker run -d \
           --workdir /usr/src/$api_name \
           --env-file $env \
           --volume /apis/keytool_files:/usr/src/$api_name/keytool_files \
           --volume /apis/oracle/sqlnet.ora:/opt/oracle/instantclient_12_2/network/admin/sqlnet.ora \
           --volume $api_path/logs:/usr/src/$api_name/logs \
           --network host \
           --health-cmd='curl -k -fsS --user $USER:$PASSWD https://localhost:$ADMIN_PORT/api/v1' \
           --health-interval=1m \
           --name $api_name \
           --restart on-failure:3 \
           $api_name:$artifact_tag \
           gulp run

if [[ ! $(docker ps -q -f name=$api_name) ]]; then
   echo "ERROR: Container not running"
   exit 1
fi
