#!/bin/bash
set -e

: "${QBT_DIR:=/opt/qbittorrent}"
: "${QBT_PROFILES_DIR:=/opt/qbittorrent/profiles}"
: "${QBT_PROFILE_NAME:=docker}"
: "${QBT_PORT_WEBUI:=8282}"
: "${QBT_PORT_NAT:=1337}"
: "${QBT_PORT_TRACKER:=9000}"

LOG_DIR="${QBT_PROFILES_DIR}/qBittorrent_${QBT_PROFILE_NAME}/data/logs"

echo "======================================================"
echo "[qbittorrent] Starting `qbittorrent-nox -v`..."
echo "======================================================"

mkdir -p "$LOG_DIR"
touch "$LOG_DIR/qbittorrent.log"
tail -n 512 -F "$LOG_DIR"/*.log &

exec qbittorrent-nox \
  --profile="${QBT_PROFILES_DIR}" \
  --configuration="${QBT_PROFILE_NAME}" \
  --webui-port="${QBT_PORT_WEBUI}"
