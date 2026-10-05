#!/bin/bash
# Perforce proxy (p4p). Settings come from the environment (defaults in epicmorg/perforce);
# extra arguments of `docker run` / compose `command` are appended to p4p.
set -euo pipefail

: "${P4PORT:=1666}"
: "${P4PCACHE:=/perforce/cache}"
: "${P4PROOT:=}"
: "${P4LOG:=/perforce/logs/p4p.log}"
: "${P4DEBUG:=}"
: "${P4ARGS:=}"
: "${P4TARGET:=}"
: "${P4MONITOR_LEVEL:=}"
: "${P4MONITOR_INTERVAL:=}"

if [[ -z "${P4TARGET}" ]]; then
  echo "[p4p] FATAL: env P4TARGET is not set (e.g. ssl:perforce.example.com:1666). Shutting down." >&2
  exit 1
fi

args=(-p "${P4PORT}" -r "${P4PCACHE}" -t "${P4TARGET}")
[[ -n "${P4PROOT}" ]] && args+=(-R "${P4PROOT}")
[[ -n "${P4LOG}" ]] && args+=(-L "${P4LOG}")
[[ -n "${P4DEBUG}" ]] && args+=(-v "${P4DEBUG}")
[[ -n "${P4MONITOR_LEVEL}" ]] && args+=(-v "proxy.monitor.level=${P4MONITOR_LEVEL}")
[[ -n "${P4MONITOR_INTERVAL}" ]] && args+=(-v "proxy.monitor.interval=${P4MONITOR_INTERVAL}")
mkdir -p "${P4PCACHE}" ${P4PROOT:+"${P4PROOT}"} ${P4LOG:+"$(dirname "${P4LOG}")"}

echo "======================================================"
echo "[p4p] Starting up: p4p ${args[*]} ${P4ARGS} $*"
echo "======================================================"

# P4ARGS is intentionally word-split: it holds several flags
# shellcheck disable=SC2086
exec p4p "${args[@]}" ${P4ARGS} "$@"
