#!/bin/bash
set -euo pipefail

# Set recommended umask of "u=,g=w,o=rwx" (0027)
umask 0027

# JAVA_HOME comes from the epicmorg/jdk base image; fall back to the java on PATH
if [ -z "${JAVA_HOME:-}" ] || [ ! -x "${JAVA_HOME}/bin/java" ]; then
    JAVA_HOME=$(dirname "$(dirname "$(readlink -f "$(command -v java)")")")
fi
export JAVA_HOME
# JDK 8 ships its JRE in $JAVA_HOME/jre, 11+ do not
if [ -x "${JAVA_HOME}/jre/bin/java" ]; then
    export JRE_HOME="${JAVA_HOME}/jre"
else
    export JRE_HOME="${JAVA_HOME}"
fi

export MESH_HOME
# start-mesh.sh would try to switch to MESH_USER itself; we drop privileges here
unset MESH_USER


# Start Mesh as the correct user
if [ "${UID}" -eq 0 ]; then
    echo "User is currently root. Will change directory ownership to ${RUN_USER}:${RUN_GROUP}, then downgrade permission to ${RUN_USER}"
    PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${MESH_HOME}")
    EXPECTED_PERMISSIONS=$(id -u ${RUN_USER}):${RUN_USER}:700
    if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
        echo "Updating permissions for MESH_HOME"
        chmod -R 700 "${MESH_HOME}" &&
            chown -R "${RUN_USER}:${RUN_GROUP}" "${MESH_HOME}"
    fi
    # Now drop privileges
    exec su -s /bin/bash "${RUN_USER}" -c "${MESH_INSTALL_DIR}/bin/start-mesh.sh $*"
else
    exec "${MESH_INSTALL_DIR}/bin/start-mesh.sh" "$@"
fi
