#!/bin/bash
# TestRail background task (notifications, reports, cleanup), run by supervisor
# as www-data every TR_DEFAULT_TASK_EXECUTION seconds.

TASK_FILE="${TR_WWW_PATH:-/var/www/testrail}/task.php"

# Stop at once on SIGTERM from supervisor (sleeps run in background + wait,
# so bash does not delay the signal until the sleep ends).
trap 'exit 0' TERM INT

echo "[testrail-task] Waiting for ${TASK_FILE}"
while [ ! -f "${TASK_FILE}" ]; do
    sleep 2 & wait $!
done

echo "[testrail-task] Started, interval ${TR_DEFAULT_TASK_EXECUTION:-60}s"
while true; do
    # Removing the memory limit for executing a PHP task
    php -d memory_limit=-1 "${TASK_FILE}" || true
    sleep "${TR_DEFAULT_TASK_EXECUTION:-60}" & wait $!
done
