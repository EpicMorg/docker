#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${TORRUST_PORT:=1337}
: ${TORRUST_ADMIN:=1488}

echo "[torrust-tracker] Starting up"
cd /app
/app/torrust-tracker