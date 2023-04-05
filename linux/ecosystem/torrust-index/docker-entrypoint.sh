#!/bin/bash
set -euo pipefail

# Setup default Opts
: ${TORRUST_PORT:=80}

echo "[torrust-index] Starting up with supervisord"
supervisord -c /etc/supervisor.conf
