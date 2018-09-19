#!/bin/bash

# garbage-collect-docker.sh
# Backs up and removes dangling docker images. Removes stopped containers
#   any image removal

###
# remove_image()
# Description: Attempts to remove an image. If a stopped container prevents
#   this, it removes the container and tries again.
# Parameters: $1 is image ID
###
remove_image()
{
    id=$1
    removal_output=$(docker rmi $id 2>&1)
    removal_exit=$(echo $?)

    # check for stopped container preventing removal
    container_id=$(echo $removal_output | sed -n -e 's/^.*stopped container //p')
    if [ $removal_exit -eq 1 ] && [ ${#container_id} -gt 1 ]
    then
        docker rm $container_id
        remove_image $id
    fi
}


###
# Main function of script
###
main()
{
    # collect IDs of dangling images
    dangling_ids=($(docker images --filter "dangling=true" --format "{{.ID}}"))

    for id in "${dangling_ids[@]}"
    do
        # backup dangling image
        $(docker save -o /Users/ecsstudent/Documents/$id.tar $id)

        # remove dangling image
        remove_image $id
    done

}

main

# remove dangling images
#for id in "${dangling_ids[@]}"
#do
 #   removal_output=$(docker rmi $id 2>&1)
  #  container_delimiter="stopped container "


#done

# select IDs older than 2 weeks
#for id in "${dangling_ids[@]}"
#do
#    image_date=$(date -j -f "%Y-%m-%d\ %H:%M:%S" +%s $(docker inspect --format='{{.Created}}' $id))
#    current_date=$(date +%s)
#    date_difference="$((current_date - image_date))"

     #echo $current_date
#     echo $image_date
     #echo $date_difference

#done
