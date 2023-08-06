#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${NINJAM_CONFIG:=example.cfg}
: ${NINJAM_PORT:=2049}
: ${NINJAM_UID:=1337} 
: ${NINJAM_ARCHIVE:=/app/archive}
: ${NINJAM_LOG:=/app/log}
: ${NINJAM_RUN:=/app/run}
: ${NINJAM_LOGFILE:=${NINJAM_LOG}/ninjamserver.log}
: ${NINJAM_PID:=${NINJAM_RUN}/ninjamserver.pid}

echo "======================================================"
echo "[NINJAM] Starting NINJAM Server..."
echo "======================================================"

cd ${NINJAM_BIN}
${NINJAM_BIN}/ninjamsrv ${NINJAM_CONFIG} -port ${NINJAM_PORT} -setuid ${NINJAM_UID} -archive ${NINJAM_ARCHIVE} -logfile ${NINJAM_LOGFILE} -pidfile ${NINJAM_PID}
