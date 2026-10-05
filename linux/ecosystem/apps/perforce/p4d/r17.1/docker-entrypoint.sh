#!/bin/bash
# Perforce Helix server (p4d) with a graceful stop.
#
# Settings: see p4d-common.sh / README (P4PORT, P4ROOT, P4JOURNAL, P4LOG, P4AUDITLOG,
# P4NAME, P4DESCRIPTION, P4CASE, P4ARGS, P4CHARSET, P4ADMIN_*, P4STOP_TIMEOUT).
# Extra arguments of `docker run` / compose `command` are appended to p4d.
# On SIGTERM / SIGINT (docker stop) the server is stopped the way Perforce wants
# it - `p4 admin stop` as a super user, so the journal and db.* files are closed
# cleanly - and only if that fails or p4d does not exit within P4STOP_TIMEOUT
# seconds it gets a SIGTERM.
set -uo pipefail
# shellcheck source=p4d-common.sh
. /usr/local/lib/p4d-common.sh
: "${P4STOP_TIMEOUT:=120}"

p4d_db_args
args=("${P4D_DB_ARGS[@]}" -p "${P4PORT}")
[[ -n "${P4NAME}" ]] && args+=(-In "${P4NAME}")
[[ -n "${P4DESCRIPTION}" ]] && args+=(-Id "${P4DESCRIPTION}")

echo "======================================================"
echo "[p4d] Starting up: p4d ${args[*]} ${P4ARGS} $*"
echo "======================================================"
# P4ARGS is intentionally word-split: it holds several flags
# shellcheck disable=SC2086
p4d "${args[@]}" ${P4ARGS} "$@" &
pid=$!

stopping=0
graceful_stop() {
  [[ ${stopping} == 1 ]] && return
  stopping=1
  p4_local
  echo "[p4d] stop requested: p4 admin stop via ${P4_LOCAL[*]:1:2}"
  p4_admin_login
  if "${P4_LOCAL[@]}" admin stop; then
    echo "[p4d] admin stop accepted, waiting up to ${P4STOP_TIMEOUT}s"
  else
    echo "[p4d] WARN: admin stop failed - sending SIGTERM to p4d"
    kill -TERM "${pid}" 2>/dev/null
  fi
  local t=0
  while kill -0 "${pid}" 2>/dev/null; do
    if (( t >= P4STOP_TIMEOUT )); then
      echo "[p4d] WARN: p4d still running after ${P4STOP_TIMEOUT}s - sending SIGTERM"
      kill -TERM "${pid}" 2>/dev/null
      break
    fi
    sleep 1; t=$((t + 1))
  done
}
trap graceful_stop TERM INT

# `wait` returns early (128+signal) when a trapped signal arrives: keep waiting
# until p4d itself has exited, then report its own exit status.
while :; do
  wait "${pid}"; rc=$?
  (( rc > 128 )) && kill -0 "${pid}" 2>/dev/null && continue   # interrupted by our trap, still running
  (( rc > 128 )) && { wait "${pid}" 2>/dev/null; r=$?; (( r != 127 )) && rc=${r}; }
  break
done
echo "[p4d] stopped (exit ${rc})"
exit "${rc}"
