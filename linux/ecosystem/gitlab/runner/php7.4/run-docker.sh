#!/bin/bash

if [ "$DOCKER_IN_DOCKER" = "start" ] ; then
 rm /var/run/docker.pid 2>/dev/null
 service docker start
 echo "Docker daemon started"
fi
