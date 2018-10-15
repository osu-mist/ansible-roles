#!/bin/sh
# kill-container.sh - ungracefully stops a docker container
# Usage: sh ./kill-container.sh
# Returns corresponding image name of killed container

killable_container_pattern="api"

IFS=$'
'
containers=($(docker container ls --format "{{.ID}}\t{{.Image}}"))
unset IFS

killable_container_exists()
{
    for container_string in "${containers[@]}"
    do
        container=($container_string)
        if [[ ${container[1]} =~ "$killable_container_pattern" ]];
        then
            return 0
        fi
    done
    return 1
}

kill_random_container()
{
    local index=$(($RANDOM%${#containers[@]}))
    local container=(${containers[$index]})
    if [[ ${container[1]} =~ "$killable_container_pattern" ]];
    then
        (docker kill ${container[0]} 2>&1)
        if [ $? -eq 0 ]
        then
            echo ${container[1]}
            exit 0
        else
            exit 1
        fi
    else
        kill_random_container
    fi
}

if killable_container_exists
then
    kill_random_container
else
    exit 0
fi
