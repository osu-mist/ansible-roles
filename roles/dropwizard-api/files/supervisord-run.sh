#!/bin/bash
# supervisord-run.sh - starts an api in the foreground
# usually run indirectly by a supervisord job
# it is not meant to be called directly

# usage: cd /apis/apis/API-NAME && sh /apis/supervisord-run.sh

set -eu

#cd "$(dirname "$0")"
name=$(basename "$(pwd)")
node="$(whoami)@$(hostname):$name"
archive=$(ls "$name"-*-all.jar | sort | tail -1)
config=/apis/config/$name.yaml
env=/apis/env/$name.env

if [ ! -e "$config" ]; then
    config=/apis/apis/$name/configuration.yaml
fi

# Read environment file
# Only allow variables that start with a capital letter
# to prevent them from overwriting our own variables.
# Don't allow overwriting the PATH variable.
if [ -r "$env" ]; then
    while IFS='\n' read -r line; do
        case "$line" in
        \#*|'')
            ;; # comment
        PATH=*)
            ;; # not allowed
        [A-Z]*=*)
            export "$line"
            ;;
        *)
            echo "ignoring invalid line \"$line\""
        esac
    done <"$env"
fi

if [ -e /apis/appd/javaagent.jar ]
then
    exec java \
        -javaagent:/apis/appd/javaagent.jar \
        -Dappdynamics.agent.applicationName="$name" \
        -Dappdynamics.agent.tierName="$name" \
        -Dappdynamics.agent.nodeName="$node" \
        -jar "$archive" \
        server \
        "$config"
else
    exec java \
        -jar "$archive" \
        server \
        "$config"
fi
