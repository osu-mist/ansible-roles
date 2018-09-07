#!/usr/bin/env  python
# collect_garbage.py - docker garbage collection script
# usage: python app.py CONFIG_FILE_PATH

import os
import sys
import yaml
import subprocess
import json
from datetime import datetime
from dateutil import parser
from dateutil.relativedelta import relativedelta


def main():
    # get configuraiton variables
    with open(sys.argv[1], 'r') as yml:
        config = yaml.load(yml)

    # get dangling IDs
    dangling_ids = get_dangling_ids()

    # filter IDs for images older than 2 weeks
    dangling_ids = select_old_ids(config, dangling_ids)

    # backup images
    backup_images(config, dangling_ids)

    # remove dangling images and broken containers
    collect_garbage(config, dangling_ids)


def get_dangling_ids():
    """Collect a list of image IDs for dangling images
    (unused by any functional container)"""
    try:
        # output of docker command is in format of one ID per line,
        # so splitline is used for parsing.
        dangling_ids = subprocess.check_output(
            ['docker images --filter "dangling=true" --format "{{.ID}}"'],
            shell=True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error getting IDs of dangling images: ' + e.output)
    return str.splitlines(dangling_ids)


def select_old_ids(config, dangling_ids):
    """Inspect each image, and return list of images that are older than
    configured minimum. Docker does not have a filter by time argument for
    listing images, only pruning them."""
    old_ids = []
    for id in dangling_ids:
        try:
            id_details = json.loads(
                subprocess.check_output(['docker inspect ' + id], shell=True))
            # Docker varies the precision/format used in the Created field,
            # so parsing the datetime requires the dateutil library.
            id_created_date = parser.parse(id_details[0]['Created'])
            threshold_date = datetime.now(
                id_created_date.tzinfo) - relativedelta(
                    hours=config['dangling_image_removal_minimum_age_hours'].
                    normalized())
            if threshold_date > id_created_date:
                old_ids.append(id)
        except subprocess.CalledProcessError as e:
            sys.exit('Error inspecting image ' + id + ": " + e.output)
    return old_ids


def backup_images(config, dangling_ids):
    """Backs up a collection of images"""
    for id in dangling_ids:
        backup_image(id, config['backup_images'])


def backup_image(image_id, path):
    """Backup image as .tar in configured backup image directory"""
    print ("Backing up " + image_id)
    try:
        subprocess.check_output(
            ['docker save --output ' + path + image_id + ".tar " + image_id],
            shell=True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error backing up image ' + image_id + ": " + e.output)


def collect_garbage(config, dangling_ids):
    """ Removes images and corresponding broken containers.
    Begins by removing the passed images.
    If an error occurs during this process involving a stopped container, this
    indicates that the corresponding container is broken and should be removed.
    This function manages backing up and removing that container, and then
    attempting to remove the image again.
    This is the clearest way to determine if a container is "bad"
    """
    for id in dangling_ids:
        output = remove_image(id)
        while "stopped container" in output[1]:
            container_id = output[1].split("stopped container ", 1)[1].strip()
            backup_container(config, container_id, id)
            remove_container(container_id)
            output = remove_image(id)


def remove_image(image_id):
    """Removes an image.
    Returns the error STDOUT and STDERR outputs.
    The STDERR output is required for handling the stopped container error."""
    try:
        removal = subprocess.Popen(
            ['docker rmi ' + image_id],
            shell=True, stdout=subprocess.PIPE,
            stderr=subprocess.PIPE)
        return removal.communicate()
    except Exception as e:
        sys.exit('Error removing image ' + image_id + ": " + e)


def backup_container(config, container_id, image_id):
    """ function description """
    try:
        output = subprocess.check_output(
            ['docker commit ' + container_id + ' broken-container:'
                + image_id],
            shell=True)
        output = output.split("sha256:", 1)[1].strip()
        backup_path = config['backup_containers'] + '/' + image_id + '/'
        if not os.path.exists(backup_path):
            os.makedirs(backup_path)
        backup_image(output, backup_path)
        remove_image(output)
    except subprocess.CalledProcessError as e:
        sys.exit('Error container backup: ' + container_id + ": " + e.output)


def remove_container(container_id):
    """Removes a container"""
    try:
        subprocess.check_output(['docker rm ' + container_id], shell=True)
    except subprocess.CalledProcessError as e:
        sys.exit('Error removing container ' + container_id + ": " + e.output)


main()
