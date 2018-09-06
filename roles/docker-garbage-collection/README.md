# Docker Garbage Collection
This role is for removing unnecessary Docker images and containers from an API server environment.

## Background
Docker's tools for system pruning removes more than wanted. It removes any container that is stopped, so that it is free to remove all dangling images.

To prune our Docker systems more conservatively, the purpose of this role is to only remove the containers that are broken (the ones preventing dangling images from being removed). It also is responsible for backing up any images or containers that are removed.

## Overview
The role does the following things (in order):

 1. Collects the IDs of any dangling images
 2. Inspects each image, and filter out images made within the last 2 weeks
 3. Attempt to remove remaining dangling images older than 2 weeks
 4. If any "stopped container" errors occur, this is an indication that the container is broken. Commits this container as an image, backs up the image, then deletes the image and container. Then, attempts to remove the dangling image that caused the error agian.
 5. TODO: Removes all images/containers older than 4 weeks from the backup

## Directories
Directories are set in the defaults.
Images are backed up to /apis/docker_garbage_collection/backup_images
Containers are backed up to /apis/docker_garbage_collection/backup_images/NAME-OF-CORRESPONDING-DANGLING-IMAGE/
Containers are committed to an image with repository = "broken-container", and the tag is the corresponding dangling image.
