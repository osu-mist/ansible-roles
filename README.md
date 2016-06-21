# Ansible Playbook: Elasticsearch Installation
Installs Elasticsearch, and get the Elasticsearch process running in the background.

### Requirements
Ansible should be installed first ([officical installation document](http://docs.ansible.com/ansible/intro_installation.html)). In addition, we should also prepare an Ansible `inventory` file to run this playbook.

**Inventory File Example:**
```
[elasticsearch-servers]
elasticsearch-servers ansible_ssh_host=127.0.0.1 ansible_ssh_port=9200 ansible_ssh_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key
```

### Usage
To run the Ansbile playbook, simply execute the following command:

`ansible-playbook -i inventory playbook/elasticsearch-servers-installation.yml`

### Playbook Tasks
-------------------
* Install [OpenJdk 7](http://openjdk.java.net/install/index.html)
* Install [Elasticsearch 2.x](https://www.elastic.co/downloads/elasticsearch)
* Run Elasticsearch in the background
