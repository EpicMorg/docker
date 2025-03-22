#!/bin/bash

# -------------------------------------------------------------------------------------
# Thread dumps collector for containerized Atlassian applications
#
# This script can be run via `docker exec` to easily trigger the collection of thread
# dumps from the containerized application. For example:
#
#     $ docker exec my_jira /opt/atlassian/support/thread-dumps.sh
#
# By default this script will collect 10 thread dumps at a 5 second interval. This can
# be overridden by passing a custom value for the count and interval, respectively. For
# example, to collect 20 thread dumps at a 3 second interval:
#
#     $ docker exec my_jira /opt/atlassian/support/thread-dumps.sh -c 20 -i 3
#
# Note: By default this script will capture output from top run in 'Thread-mode'. This can
# be disabled by passing --no-top
# -------------------------------------------------------------------------------------


set -euo pipefail


# Set up common vars like APP_NAME, APP_HOME, APP_PID
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/common.sh"

# Set up script opts
set_valid_options "c:i:n" "count:,interval:,no-top"

# Set defaults
COUNT="10"
INTERVAL="5"
NO_TOP="false"

# Parse opts
while true; do
    case "${1-}" in
        -c | --count )      COUNT="$2"; shift 2 ;;
        -i | --interval )   INTERVAL="$2"; shift 2 ;;
        -n | --no-top )     NO_TOP="true"; shift ;;
        * ) break ;;
    esac
done



echo "Atlassian thread dump collector"
echo "App:       ${APP_NAME}"
echo "Run user:  ${RUN_USER}"
echo
echo "${COUNT} thread dumps will be generated at a ${INTERVAL} second interval"
if [[ "${NO_TOP}" == "false" ]]; then
    echo "top 'Threads-mode' output will also be collected for ${APP_NAME} with every thread dump"
fi
echo

OUT_DIR="$(get_app_home)/thread_dumps/$(date +'%Y-%m-%d_%H-%M-%S')"
run_as_runuser mkdir -p ${OUT_DIR}

for i in $(seq ${COUNT}); do
    echo "Generating thread dump ${i} of ${COUNT}"
    if [[ "${NO_TOP}" == "false" ]]; then
        run_as_runuser top -b -H -p $JVM_APP_PID -n 1 > "${OUT_DIR}/${APP_NAME}_CPU_USAGE.$(date +%s).txt"
    fi
    run_as_runuser ${JCMD} ${JVM_APP_PID} Thread.print -l > "${OUT_DIR}/${APP_NAME}_THREADS.$(date +%s).txt"
    if [[ ! "${i}" == "${COUNT}" ]]; then
        sleep ${INTERVAL}
    fi
done

echo
echo "Thread dumps have been written to ${OUT_DIR}"
