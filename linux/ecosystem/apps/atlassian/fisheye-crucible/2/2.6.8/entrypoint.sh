#!/bin/bash
set -euo pipefail

# Set up FISHEYE_OPTS
: ${JVM_MINIMUM_MEMORY:=}
: ${JVM_MAXIMUM_MEMORY:=}
: ${JVM_SUPPORT_RECOMMENDED_ARGS:=}

: ${FISHEYE_OPTS:=}

if [ "${JVM_MINIMUM_MEMORY}" != "" ]; then
    FISHEYE_OPTS="${FISHEYE_OPTS} -Xms${JVM_MINIMUM_MEMORY}"
fi
if [ "${JVM_MAXIMUM_MEMORY}" != "" ]; then
    FISHEYE_OPTS="${FISHEYE_OPTS} -Xmx${JVM_MAXIMUM_MEMORY}"
fi

export FISHEYE_OPTS="${FISHEYE_OPTS} ${JVM_SUPPORT_RECOMMENDED_ARGS}"

# Start Bamboo as the correct user
if [ "${UID}" -eq 0 ]; then
    echo "User is currently root. Will change directory ownership to ${RUN_USER}:${RUN_GROUP}, then downgrade permission to ${RUN_USER}"
    PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${FISHEYE_INST}")
    EXPECTED_PERMISSIONS=$(id -u ${RUN_USER}):${RUN_USER}:700
    if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
        chmod -R 700 "${FISHEYE_INST}" &&
            chown -R "${RUN_USER}:${RUN_GROUP}" "${FISHEYE_INST}"
    fi
    # Now drop privileges
    exec su -s /bin/bash "${RUN_USER}" -c "$FISHEYE_HOME/bin/fisheyectl.sh $@"
else
    exec "$FISHEYE_HOME/bin/fisheyectl.sh" "$@"
fi
