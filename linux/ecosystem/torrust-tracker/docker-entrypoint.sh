#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${RACKER_PORT:=1337}
: ${RACKER_ADMIN:=1488}

echo "[torrust-tracker] Starting up"
cd /app
/app/torrust-tracker
