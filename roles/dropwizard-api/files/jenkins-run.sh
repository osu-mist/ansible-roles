#!/bin/sh
# jenkins-run.sh - starts or restarts an api with supervisorctl
# usually called remotely by jenkins

# usage: jenkins-run.sh API-NAME

set -eu

api=${1:-}
if [ -z "$api" ]; then
    echo 2>&1 "usage: jenkins-run.sh API-NAME"
    exit 1
fi
if [ "$(echo $api | tr -d "A-Za-z0-9-_")" ]; then
    echo 2>&1 "invalid api name: $api"
    exit 1
fi
if [ ! -d /apis/apis/"$api" ]; then
    echo 2>&1 "api does not exist: $api"
    exit 1
fi

# Make service if it does not exist
if [ ! -e /apis/run.d/"$api".conf ]; then
    echo "Creating a supervisord service file for $api."
    sed -e s/API/"$api"/g </apis/run.d/template >/apis/run.d/"$api".conf
fi

xsupervisorctl() {
    supervisorctl -c /apis/supervisor/supervisord.conf "$@"
}

echo "Restarting $api..."
xsupervisorctl update            # make sure the config is loaded
xsupervisorctl clear "$api"      # clear the logs
xsupervisorctl restart "$api"
# supervisorctl restart exits with 0 whether or not the process
# was successfully started, so we have to use this hack to
# check whether it is running or not
if [ "$(xsupervisorctl pid "$api")" -eq 0 ]; then
    # print out the log so we can see what went wrong
    echo "Failed to start $api."
    echo "Printing the last 10000 characters of ${api}.log:"
    xsupervisorctl tail -10000 "$api"
    exit 1
fi
