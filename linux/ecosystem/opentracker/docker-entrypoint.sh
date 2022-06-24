#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${RETRACKER_BIN:=opentracker}
: ${RETRACKER_PORT:=6969}
: ${RETRACKER_CONFIG:=/etc/opentracker/opentracker.conf}
: ${RETRACKER_DEBUG:=false}
: ${RETRACKER_OPTS:=}

if [[ -z "${RETRACKER_DEBUG}" ]]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is not set. Skipping..."
  export RETRACKER_BIN="opentracker"
elif [ "${RETRACKER_DEBUG}" == "false" ]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is set to false. Skipping..."
  export RETRACKER_BIN="opentracker"
elif  [ "${RETRACKER_DEBUG}" == "true" ]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is set to true. Enabling it."
  export RETRACKER_BIN="opentracker.debug"
else
  echo "[retracker] Debug env RETRACKER_DEBUG is set to strange value. Skipping..."
  export RETRACKER_BIN="opentracker"
fi


echo "[opentracker] Starting up"
${RETRACKER_BIN} ${RETRACKER_OPTS} -f ${RETRACKER_CONFIG}
