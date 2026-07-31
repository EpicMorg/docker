#!/bin/bash

: ${P4ARGS:=}
: ${P4DEBUG:=}
: ${P4PROOT:=}
: ${P4PCACHE:=/perforce/cache}
: ${P4LOG:=/perforce/logs/p4p.log}
: ${P4TARGET:=}
: ${P4PORT:=1666}

if [[ -z "${P4TARGET}" ]]; then
  echo "[p4p] FATAL: env P4TARGET is not set. Please, set it and try again. Shutting down."
  exit 1
fi

echo "======================================================"
echo "[p4p] Starting up..."
echo "======================================================"

p4p -p ${P4PORT} -r ${P4CACHE} -t ${P4TARGET} -L ${P4LOG} ${P4ARGS}
