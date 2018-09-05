# Chaos Beaver
This is the public role component of Chaos Beaver. It is responsible for configuring up the API server environment for chaos commands from a Jenkins job. The management of chaos commands, follow-up integration testing, and notifications are in the private role component of Chaos Beaver.

## Container chaos
This role generates the files needed for a Jenkins job to kill a container. In this context, "kill" means sending the SIGKILL signal to the container. SIGKILL indicates that the container should be killed immediately, with no chance to gracefully stop or cleanup. This simulates a sudden, unexpected failure of a container.

### Usage
To kill a container, a Jenkins job should run:

`/apis/chaos/jenkins-kill.sh CONTAINER-NAME`
