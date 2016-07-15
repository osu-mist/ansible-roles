# Ansible Roles
Collect Ansible roles for automatical deployment.

### Requirements
----------------
1. Ansible should be [installed](http://docs.ansible.com/ansible/intro_installation.html) first. In addition, we should also prepare an Ansible `inventory` file to run this playbook.

	**Inventory File Example:**
	```
	[jenkins-servers]
	jenkins-servers ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
	```

2. All roles are developed base on [CentOS 6.4](http://vault.centos.org/6.4/), ensure remoted machines have the same OS.

### Usage
---------
1. Modify your Ansbile playbook as needed.

	**Playbook Example:**
	```yaml
	---
	- hosts: servers
	  roles:
	    - {role: dropwizard-api, become: yes}
    	- {role: hubot, become: yes}
	```

2. To run the Ansbile playbook, simply execute the following command:

	`ansible-playbook -i inventory example-main.yml`

### Main Roles List
-------------------
* [Dropwizard API](role/dropwizard-api)

	* Description: Create user and group for the API, then deploy the API repo to certain directories.

* [Elasticsearch](role/elasticsearch)

	* Description: Install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) and ensure the service is running.

* [HUBOT](role/hubot)

	* Description: Install [HUBOT](https://hubot.github.com/) and ensure the service is running.
