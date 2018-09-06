#!/usr/bin/env  python

# app.py - docker garbage collection script
# usage: python app.py CONFIG_FILE_PATH

import os
import sys
import yaml
import subprocess
import json
from datetime import datetime
from dateutil import parser
from dateutil.relativedelta import *

def main():
    # get configuraiton variables
    with open(sys.argv[1], 'r') as yml:
        config = yaml.load(yml)

    # get dangling IDs
    danglingIDs = getDanglingIDs()

    # filter IDs for images older than 2 weeks
    danglingIDs = selectOldIDs(config, danglingIDs)

    # backup images
    backupImages(config, danglingIDs)

    # remove dangling images and broken containers
    garbageCollect(config, danglingIDs)

# Collect a list of image IDs for dangling images (unused by any functional container)
def getDanglingIDs():
    try:
        # output of docker command is in format of one ID per line, so splitline is used for parsing.
        danglingIDs = subprocess.check_output(['docker images --filter "dangling=true" --format "{{.ID}}"'], shell = True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error getting IDs of dangling images: ' + e.output)
    return str.splitlines(danglingIDs)

# Inspect each image, and return list of images that are older than configured minimum.
# Docker does not have a filter by time argument for listing images, only pruning them ( docker -- ).
def selectOldIDs(config, danglingIDs):
    oldIDs = []
    for id in danglingIDs:
        try:
            idDetails = json.loads(subprocess.check_output(['docker inspect ' + id], shell = True))
             # Docker varies the precision/format used in the Created field, so parsing the datetime requires the dateutil library.
            idCreatedDate = parser.parse(idDetails[0]['Created'])
            if datetime.now(idCreatedDate.tzinfo) - relativedelta(hours=config['dangling_image_removal_minimum_age_hours']).normalized() > idCreatedDate:
                oldIDs.append(id)
        except subprocess.CalledProcessError as e:
            sys.exit('Error inspecting image ' + id + ": " + e.output)
    return oldIDs

# Backs up a collection of images
def backupImages(config, danglingIDs):
    for id in danglingIDs:
        backupImage(id, config['backup_images'])

# Backup image as .tar in configured backup image directory
def backupImage(imageID, path):
    print ("Backing up " + imageID)
    try:
        subprocess.check_output(['docker save --output ' + path + imageID + ".tar " + imageID], shell=True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error backing up image ' + imageID + ": " + e.output)

# Removes images and corresponding broken containers.
# Begins by removing the passed images. If an error occurs during this process involving a stopped container, this indicates that
#   the corresponding container is broken and should be removed.
# This function manages backing up and removing that container, and then attempting to remove the image again.
# This is the clearest way to determine if a container is "bad"
# Docker's suggested way of determining if a container is "bad" is only to check if it is stopped (docker --)
def garbageCollect(config, danglingIDs):
    for id in danglingIDs:
        output = removeImage(id)
        while "stopped container" in output[1]:
            containerID = output[1].split("stopped container ", 1)[1].strip()
            backupContainer(config, containerID, id)
            removeContainer(containerID)
            output = removeImage(id)

# Removes an image.
# Returns the error STDOUT and STDERR outputs. The STDERR output is required for handling the stopped container error.
def removeImage(imageID):
    try:
        removal = subprocess.Popen(['docker rmi ' + imageID], shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return removal.communicate()
    except Exception as e:
        sys.exit('Error removing image ' + imageID + ": " + e)

# Backs up a container.
# Containers can only be backed up by commiting it as an image.
# This function commits the container as an image, saves that image in the configured backup container directory,
#   then deletes the image (not the container)
def backupContainer(config, containerID, imageID):
    try:
        output = subprocess.check_output(['docker commit ' + containerID + ' broken-container:' + imageID], shell = True)
        output = output.split("sha256:", 1)[1].strip()
        backupPath = config['backup_containers'] + '/' + imageID + '/'
        if not os.path.exists(backupPath):
            os.makedirs(backupPath)
        backupImage(output, backupPath)
        removeImage(output)
    except subprocess.CalledProcessError as e:
        sys.exit('Error backing up container ' + containerID + ": " + e.output)

# Removes a container
def removeContainer(containerID):
    try:
        subprocess.check_output(['docker rm ' + containerID], shell = True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error removing container ' + containerID + ": " + e.output)

main()
