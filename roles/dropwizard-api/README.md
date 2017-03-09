The dropwizard-api role sets up a server for continuous deployment
of dropwizard apis.

The general process of deploying an API is

1. Copy the shadow jar to /apis/apis/API/API-whatever-all.jar

2. Ensure that either /apis/apis/API/configuration.yaml or
   /apis/config/API.yaml is present. Can either be installed
   ahead of time or copied along with the jar

3. Write environment variables to /apis/env/API.env, in the form

        # This line is a comment
        PORT=8080
        USER=admin
        PASSWORD=!@#$^*"'

    etc. No quoting is necessary. Variables must start with an uppercase
    letter, and setting PATH is not allowed.

3. Run /apis/jenkins-run.sh API

... where API stands for the name of the api.
