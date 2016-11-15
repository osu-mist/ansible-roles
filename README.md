# Ansible Roles
Collect Ansible roles for automatical deployment.

### Requirements
----------------
1. [Ansible (version 2.1)](https://github.com/ansible/ansible) should be [installed](http://docs.ansible.com/ansible/intro_installation.html) first. In addition, we should also prepare an Ansible `inventory` file to run this playbook.

	**Inventory File Example:**
	```
	[servers]
	servers ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
	```

2. All roles are developed base on [CentOS 6.7](http://vault.centos.org/6.7/), ensure remoted machines have the same OS.

### Usage
---------
1. Modify your Ansbile playbook as needed.

	**Playbook Example:**
	```yaml
	---
	- hosts: servers
	  roles:
	    - { role: dropwizard-api, become: yes }
    	- { role: hubot, become: yes }
	```

2. To run the Ansbile playbook, simply execute the following command:

	`ansible-playbook -i inventory example-main.yml`

### Main Roles List
-------------------
* [docker](roles/docker)

	* Description: This role installs Docker on to a Debian Jessie 8.X system.
	
* [dropwizard-api](roles/dropwizard-api)

	* Description: Create user and group for the API. Also, deploy the API repo to certain directories.

* [keytools](roles/keytools)

	* Description: Generate / refresh certificates and backup old certificates.

* [elasticsearch](roles/elasticsearch)

	* Description: Install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) and ensure the service is running.

* [hubot](roles/hubot)

	* Description: Install [HUBOT](https://hubot.github.com/) and ensure the service is running.
