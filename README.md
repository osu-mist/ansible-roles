# Ansible Roles ![Ansible](https://img.shields.io/badge/Ansible-2.5.6-blue.svg)
Collect Ansible roles for automatic deployment.

### Requirements
----------------
1. [Ansible (version 2.5.6)](https://github.com/ansible/ansible) should be [installed](http://docs.ansible.com/ansible/intro_installation.html) first. In addition, we should also prepare an Ansible `inventory` file to run this playbook.

	**Inventory File Example:**
	```
	[servers]
	servers ansible_ssh_host=127.0.0.1 ansible_ssh_port=2222 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
	```

2. All roles are developed base on [CentOS 6.7](http://vault.centos.org/6.7/), ensure remote machines have the same OS.

### Usage
---------
1. Modify your Ansible playbook as needed.

	**Playbook Example:**
	```yaml
  ---
  - hosts: servers
    roles:
      - { role: dropwizard-api, become: yes }
    	- { role: hubot, become: yes }
	```

2. Copy vault-example.yml to vault.yml, modify values as necessary, and encrypt vault.yml:
```bash
$ ansible-vault encrypt vault.yml
```
and enter a password for the encrypted file when prompted.

3. Run the Ansible playbook:
```bash
$ ansible-playbook -i inventory example-main.yml
```
and add `--vault-id /path/to/vault/password-file` to specify vault password file or `--vault-id @prompt` to be prompted for vault password


### Main Roles List
-------------------
* [dropwizard-api](roles/dropwizard-api)

	* Description: Create user and group for the API. Also, deploy the API repo to certain directories.

* [keytools](roles/keytools)

	* Description: Generate / refresh certificates and backup old certificates.

* [elasticsearch](roles/elasticsearch)

	* Description: Install [Elasticsearch](https://www.elastic.co/downloads/elasticsearch) and ensure the service is running.
