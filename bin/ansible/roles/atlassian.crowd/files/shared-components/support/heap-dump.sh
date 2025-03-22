#!/bin/bash

# -------------------------------------------------------------------------------------
# Heap collector for containerized Atlassian applications
#
# This script can be run via `docker exec` to easily trigger the collection of a heap
# dump from the containerized application. For example:
#
#     $ docker exec -it my_jira /opt/atlassian/support/heap-dump.sh
#
# A heap dump will be written to $APP_HOME/heap.bin. If a file already exists at this
# location, use -f/--force to overwrite the existing heap dump file.
#
# -------------------------------------------------------------------------------------


set -euo pipefail


# Set up common vars like APP_NAME, APP_HOME, APP_PID
SCRIPT_DIR=$(dirname "$0")
source "${SCRIPT_DIR}/common.sh"

# Set up script opts
set_valid_options "f" "force"

# Set defaults
OVERWRITE="false"

# Parse opts
while true; do
    case "${1-}" in
        -f | --force ) OVERWRITE="true"; shift ;;
        * ) break ;;
    esac
done



echo "Atlassian heap dump collector"
echo "App:       ${APP_NAME}"
echo "Run user:  ${RUN_USER}"
echo

OUT_FILE="$(get_app_home)/heap.bin"

if [[ -f "${OUT_FILE}" ]]; then
    echo "A previous heap dump already exists at ${OUT_FILE}."
    if [[ "${OVERWRITE}" == "true" ]]; then
        echo "Removing previous heap dump file"
        echo
        rm "${OUT_FILE}"
    else
        echo "Use -f/--force to overwrite the existing heap dump."
        exit
    fi
fi

echo "Generating heap dump"
run_as_runuser ${JCMD} ${JVM_APP_PID} GC.heap_dump -all ${OUT_FILE} > /dev/null
echo
echo "Heap dump has been written to ${OUT_FILE}"
