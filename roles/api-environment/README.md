API Environment
===

This role sets up servers environment to run different kind of APIs within docker containers. The following are three main parts of this role.

## Generic Tasks

In this stage, an api user will be created if not exists yet. Please note that **DO NOT** put plaintext passwords in your playbook or host_vars; instead, use [Using Vault in playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_vault.html) to encrypt sensitive data.

## Dropwizard API

By enabling `dropwizard_api: true`, this role will start the process of setting up environment for Dropwizard based APIs. The general process of deploying a Dropwizard API is:

  1. Copy the shadow jar to `/apis/apis/<api_name>/<api_name>-whatever-all.jar`
  2. Ensure that either `/apis/apis/<api_name>/configuration.yaml` or `/apis/config/<api_name>.yaml` is present. Can either be installed ahead of time or copied along with the jar
  3. Write environment variables to `/apis/env/<api_name>.env`, in the form:

      ```
      # This line is a comment
      PORT=8080
      USER=admin
      PASSWORD=!@#$^*"'
      ```

    etc. No quoting is necessary. Variables must start with an uppercase letter, and setting PATH is not allowed.

  4. Run `/apis/jenkins-run.sh <api_name>`

## Express API

By enabling `express_api: true`, this role will start the process of setting up environment for Express based APIs. The general process of deploying an Express API is:

  1. Copy the archived container to `/apis/apis/<api_name>/<api_name>-whatever.tar`
  2. Import the tar file as a new image, and mount the env file into the container
  3. Run `/apis/jenkins-express-run.sh <api_name>` to start the API container
