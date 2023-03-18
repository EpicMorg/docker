#!/bin/bash

##############################################################################
#
# This script will initiate a clean shutdown of the application, and
# then wait for the process to finish before returning. This is
# primarily intended for use in environments that provide an orderly
# shutdown mechanism, in particular the Kubernetes `preStop` hook.
#
# This script will wait for the process to exit indefinitely; however
# most run-time tools (including Docker and Kubernetes) have their own
# shutdown timeouts that will send a SIGKILL if the grace period is
# exceeded.
#
##############################################################################

set -e

source /opt/atlassian/support/common.sh

echo "Shutting down Crowd..."
echo ${JVM_APP_PID} > ${CROWD_INSTALL_DIR}/apache-tomcat/work/catalina.pid

if [[ "${UID}" == 0 ]]; then
    /bin/su ${RUN_USER} -c ${CROWD_INSTALL_DIR}/stop_crowd.sh;
else
    ${CROWD_INSTALL_DIR}/stop_crowd.sh;
fi

/opt/atlassian/support/wait-pid.sh ${JVM_APP_PID}
