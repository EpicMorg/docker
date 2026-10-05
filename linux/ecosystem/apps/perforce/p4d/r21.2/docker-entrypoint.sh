#!/bin/bash
# Perforce Helix server (p4d) with a graceful stop.
#
# Settings come from the environment; extra arguments of `docker run` / compose
# `command` are appended to p4d. On SIGTERM / SIGINT (docker stop) the server is
# stopped the way Perforce wants it - `p4 admin stop` as a super user, so the
# journal and db.* files are closed cleanly - and only if that fails or p4d does
# not exit within P4STOP_TIMEOUT seconds it gets a SIGTERM.
#
#   P4PORT            listen port / address            (1666; ssl:1666 for SSL)
#   P4ROOT            server root (db.*, depots)       (/perforce/root)
#   P4JOURNAL         journal file                     (journal, relative to P4ROOT)
#   P4LOG             error log                        (/perforce/logs/p4d.log)
#   P4AUDITLOG        audit log, empty = off           ()
#   P4NAME            server name (-In), empty = none  ()
#   P4DESCRIPTION     server description (-Id)         ()
#   P4CASE            1 = case-insensitive (-C1)       ()
#   P4ARGS            any further p4d flags, word-split ()
#   P4ADMIN_USER      super user for `p4 admin stop`   ()
#   P4ADMIN_PASSWD    its password                     ()
#   P4ADMIN_PASSWD_FILE  file with the password (Docker secrets) - wins over P4ADMIN_PASSWD
#   P4STOP_TIMEOUT    seconds to wait for p4d to exit  (120)
# Without P4ADMIN_USER `p4 admin stop` is still tried (works on a server without
# protections or with a valid ticket in P4TICKETS / ~/.p4tickets).
set -uo pipefail

: "${P4PORT:=1666}"
: "${P4ROOT:=/perforce/root}"
: "${P4JOURNAL:=journal}"
: "${P4LOG:=/perforce/logs/p4d.log}"
: "${P4AUDITLOG:=}"
: "${P4NAME:=}"
: "${P4DESCRIPTION:=}"
: "${P4CASE:=}"
: "${P4ARGS:=}"
: "${P4ADMIN_USER:=}"
: "${P4ADMIN_PASSWD:=}"
: "${P4ADMIN_PASSWD_FILE:=}"
: "${P4STOP_TIMEOUT:=120}"

args=(-r "${P4ROOT}" -p "${P4PORT}" -J "${P4JOURNAL}")
[[ -n "${P4LOG}" ]] && args+=(-L "${P4LOG}")
[[ -n "${P4AUDITLOG}" ]] && args+=(-A "${P4AUDITLOG}")
[[ -n "${P4NAME}" ]] && args+=(-In "${P4NAME}")
[[ -n "${P4DESCRIPTION}" ]] && args+=(-Id "${P4DESCRIPTION}")
[[ "${P4CASE}" == 1 ]] && args+=(-C1)
mkdir -p "${P4ROOT}" ${P4LOG:+"$(dirname "${P4LOG}")"} ${P4AUDITLOG:+"$(dirname "${P4AUDITLOG}")"}

# Address `p4 admin stop` talks to: same protocol and port, on localhost.
port="${P4PORT##*:}"
proto=""; [[ "${P4PORT}" == ssl* ]] && proto="ssl:"
client_port="${proto}localhost:${port}"

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
  echo "[p4d] stop requested: p4 admin stop via ${client_port}"
  local p4=(p4 -p "${client_port}")
  [[ -n "${P4ADMIN_USER}" ]] && p4+=(-u "${P4ADMIN_USER}")
  [[ -n "${proto}" ]] && "${p4[@]}" trust -y >/dev/null 2>&1
  local pass="${P4ADMIN_PASSWD}"
  [[ -n "${P4ADMIN_PASSWD_FILE}" && -r "${P4ADMIN_PASSWD_FILE}" ]] && pass="$(<"${P4ADMIN_PASSWD_FILE}")"
  if [[ -n "${pass}" ]]; then
    printf '%s\n' "${pass}" | "${p4[@]}" login >/dev/null 2>&1 || echo "[p4d] WARN: login as ${P4ADMIN_USER:-<default user>} failed"
  fi
  if "${p4[@]}" admin stop; then
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
