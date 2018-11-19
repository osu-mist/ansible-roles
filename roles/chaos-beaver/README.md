# Chaos Beaver
This is the public role component of Chaos Beaver. It is responsible for configuring the API server environment with a script to be called from Jenkins. This script randomly selects a killable container, attempts to kill it, and outputs the name of the corresponding image of the killed script. The management of kill commands, hipchat notifications, and follow-up integration testing are configured in the private role component of Chaos Beaver.

## Container chaos
This role generates the files needed for a Jenkins job to kill a container. In this context, "kill" means sending the SIGKILL signal to the container. SIGKILL indicates that the container should be killed immediately, with no chance to gracefully stop or cleanup. This simulates a sudden, unexpected failure of a container.

### Usage
To kill a container, a Jenkins job should run:

`sh ./chaos/jenkins-kill.sh `

If the container killing is successful, it returns the corresponding image name.
If the container killing fails, exit code 1 is returned.
If there is no container to kill, exit code 0 is returned, but no image name is output.
