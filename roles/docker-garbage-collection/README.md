# Docker Garbage Collection
This role is for removing unnecessary Docker images and containers from an API server environment.

## Background
Docker's tools for system pruning removes more than wanted. It removes any container that is stopped, so that it is free to remove all dangling images.

To prune our Docker systems more conservatively, the purpose of this role is to only remove the containers that are broken (the ones preventing dangling images from being removed). It also is responsible for backing up any images that are removed.

## Overview
The role does the following things (in order):

 1. Collects the IDs of any dangling images
 2. Backs up each dangling image to the backup directory specified in defaults
 3. Attempt to remove remaining dangling images.
 4. If any "stopped container" errors occur, this is an indication that the container is broken. Deletes this container, then attempts to remove the dangling image that caused the error again.
 5. TODO: Removes all images/containers older than 4 weeks from the backup
 6. TODO: Log images and container removal

## Image Recovery
Backed up images can be recovered by doing the following:

    1. Load the image into docker using `docker load`
    2. Remove or rename any current images that have the repo/tag of this image
    3. Rename the repo/tag of the imported dangling image using `docker image tag`
