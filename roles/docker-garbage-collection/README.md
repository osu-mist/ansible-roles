# Docker Garbage Collection
This role is for removing unnecessary Docker images and containers from an API server environment.

## Background
Docker's tools for system pruning removes more than wanted. It removes any container that is stopped, so that it is free to remove all dangling images.

To prune our Docker systems more conservatively, the purpose of this role is to only remove the containers that are broken (the ones preventing dangling images from being removed). It also is responsible for backing up any images that are removed.

## Overview
The role does the following things (in order):

 1. Collects the IDs of any dangling images.
 2. Backs up each dangling image to the backup directory specified in defaults.
 3. Attempt to remove remaining dangling images.
 4. If any "stopped container" errors occur, this is an indication that the container is broken. Deletes this container, then attempts to remove the dangling image that caused the error again.
 5. Removes all images/containers older than the backup_max_age parameter from the backup.

 Any backup or removal of images or containers is logged at the log_file location parameter. Removal of old backups is logged as well.

## Example playbook running only this role:
    ---
        - hosts: api_servers_local

          vars_files:
          - ansible-private-roles/vault.yml
          - ansible-roles/vault.yml

          tasks:
            - name: set up API environment
              import_role:
                name: docker-garbage-collection
              become: yes

### Example api-inv for API server
    [api_servers_local]
    192.168.33.2

    [api_servers_local:vars]
    ansible_ssh_user=vagrant

### Example playbook execution:
`ansible-playbook -i api-inv api.yml --ask-become-pass -v`

## Image Recovery
Backed up images can be recovered by doing the following:

1. Load the image into docker using `docker load`
2. Remove or rename any current images that have the repo/tag of this image
3. Rename the repo/tag of the imported dangling image using `docker image tag`

## Dangling Image Case Tests
The decisions of what this role backs up and deletes were made by testing several image/container failure scenarios. A summary of the results:
- When a image cannot be removed due to a stopped container, this means that the image failed during the build process, and the stopped container is an intermediate layer.
    - Exporting and reimporting this stopped container results in another dangling image that, when run, creates another broken stopped container.
    - These images fail to build, but are backed up for debugging. The container is not backed up as it only generates a similar image (described above)
- When an image can be removed without error, it is likely an image that was successfully built, but has been replaced by a newer one. It can be reimported and made non-dangling as described in Image Recovery. To avoid the newer image becoming a dangling image, rename it as described in Image Recovery.
- It is plausible that stopped containers and unused networks could be reused in the docker environment. Docker prune removes these. This role does not remove any networks, and only removes dangling images and the "broken containers" described above.
