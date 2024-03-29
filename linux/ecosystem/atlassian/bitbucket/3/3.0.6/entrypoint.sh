#!/bin/bash
set -euo pipefail

# Set recommended umask of "u=,g=w,o=rwx" (0027)
umask 0027

export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
export JRE_HOME="$JAVA_HOME/jre"
export JAVA_BINARY="$JRE_HOME/bin/java"
export JAVA_VERSION=$("$JAVA_BINARY" -version 2>&1 | awk -F '"' '/version/ {print $2}')

#export PATH=$JAVA_HOME/bin:$PATH


# Setup Catalina Opts
: ${CATALINA_CONNECTOR_PROXYNAME:=}
: ${CATALINA_CONNECTOR_PROXYPORT:=}
: ${CATALINA_CONNECTOR_SCHEME:=http}
: ${CATALINA_CONNECTOR_SECURE:=false}

: ${CATALINA_OPTS:=}

: ${JAVA_OPTS:=}

: ${ELASTICSEARCH_ENABLED:=true}
: ${APPLICATION_MODE:=}

CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyName=${CATALINA_CONNECTOR_PROXYNAME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorProxyPort=${CATALINA_CONNECTOR_PROXYPORT}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorScheme=${CATALINA_CONNECTOR_SCHEME}"
CATALINA_OPTS="${CATALINA_OPTS} -DcatalinaConnectorSecure=${CATALINA_CONNECTOR_SECURE}"

JAVA_OPTS="${JAVA_OPTS} ${CATALINA_OPTS}"

ARGS="$@"

# Start Bitbucket without Elasticsearch
if [ "${ELASTICSEARCH_ENABLED}" == "false" ] || [ "${APPLICATION_MODE}" == "mirror" ]; then
    ARGS="--no-search ${ARGS}"
fi

# Start Bitbucket as the correct user.
if [ "${UID}" -eq 0 ]; then
    echo "User is currently root. Will change directory ownership to ${RUN_USER}:${RUN_GROUP}, then downgrade permission to ${RUN_USER}"
    PERMISSIONS_SIGNATURE=$(stat -c "%u:%U:%a" "${BITBUCKET_HOME}")
    EXPECTED_PERMISSIONS=$(id -u ${RUN_USER}):${RUN_USER}:700
    if [ "${PERMISSIONS_SIGNATURE}" != "${EXPECTED_PERMISSIONS}" ]; then
        echo "Updating permissions for BITBUCKET_HOME"
        mkdir -p "${BITBUCKET_HOME}/lib" &&
            chmod -R 700 "${BITBUCKET_HOME}" &&
            chown -R "${RUN_USER}:${RUN_GROUP}" "${BITBUCKET_HOME}"
    fi
    # Now drop privileges
    exec su -s /bin/bash "${RUN_USER}" -c "${BITBUCKET_INSTALL_DIR}/bin/start-stash.sh ${ARGS}"
else
    exec "${BITBUCKET_INSTALL_DIR}/bin/start-stash.sh" ${ARGS}
fi
