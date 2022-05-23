#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${RETRACKER_PORT:=80}
: ${RETRACKER_MINUTS:=180}
: ${RETRACKER_DEBUG:=false}
: ${RETRACKER_REAL_IP:=true}
re='^[0-9]+$'


if [[ -z "${RETRACKER_REAL_IP}" ]]; then
  echo "[retracker] RemoteAddr from X-Real-IP header env RETRACKER_REAL_IP is not set. Skipping..."
  export RETRACKER_REAL_IP_S=""
elif [ "${RETRACKER_REAL_IP}" == "false" ]; then
  echo "[retracker] RemoteAddr from X-Real-IP header env RETRACKER_REAL_IP is set to false. Skipping..."
  export RETRACKER_REAL_IP_S=""
elif  [ "${RETRACKER_REAL_IP}" == "true" ]; then
  echo "[retracker] RemoteAddr from X-Real-IP header env RETRACKER_REAL_IP is set to true. Enabling it."
  export RETRACKER_REAL_IP_S="-x"
else
  echo "[retracker] RemoteAddr from X-Real-IP header env RETRACKER_REAL_IP is set to strange value. Skipping..."
  export RETRACKER_REAL_IP_S=""
fi


if [[ -z "${RETRACKER_DEBUG}" ]]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is not set. Skipping..."
  export RETRACKER_DEBUG_S=""
elif [ "${RETRACKER_DEBUG}" == "false" ]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is set to false. Skipping..."
  export RETRACKER_DEBUG_S=""
elif  [ "${RETRACKER_DEBUG}" == "true" ]; then
  echo "[retracker] Debug env RETRACKER_DEBUG is set to true. Enabling it."
  export RETRACKER_DEBUG_S="-d"
else
  echo "[retracker] Debug env RETRACKER_DEBUG is set to strange value. Skipping..."
  export RETRACKER_DEBUG_S=""
fi


if ! [[ $RETRACKER_PORT =~ $re ]] ; then
   echo "[retracker] error: Port env RETRACKER_PORT not a number."
   export RETRACKER_PORT_S=""
   exit 1
fi
echo "[retracker] Port env RETRACKER_PORT is set to ${RETRACKER_PORT}."
export RETRACKER_PORT_S="-l :${RETRACKER_PORT}"


if ! [[ $RETRACKER_MINUTS =~ $re ]] ; then
   echo "[retracker] error: Port env RETRACKER_MINUTS not a number."
   export RETRACKER_MINUTS_S=""
   exit 1
fi
echo "[retracker] Keep N minutes env RETRACKER_MINUTS peer in memory is set to ${RETRACKER_MINUTS}."
export RETRACKER_MINUTS_S="-a ${RETRACKER_MINUTS}"

#Building final options string
echo "[retracker] Building final options string: ${RETRACKER_OPTS}"
export RETRACKER_OPTS="${RETRACKER_REAL_IP_S} ${RETRACKER_DEBUG_S} ${RETRACKER_MINUTS_S} ${RETRACKER_PORT_S}"

echo "[retracker] Starting up"
retracker -v
retracker ${RETRACKER_OPTS}
