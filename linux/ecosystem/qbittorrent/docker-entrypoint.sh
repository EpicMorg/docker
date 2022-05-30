#!/bin/bash

: ${QBT_PROFILES_DIR:=/opt/qbittorrent/profiles}
: ${QBT_PROFILE_NAME:=docker}
: ${QBT_PORT_WEBUI:=8282}
: ${QBT_PORT_TRACKER:=9000}


echo "======================================================"
echo "[qbittorrent] Starting `qbittorrent-nox -v`..."
echo "======================================================"

tail -n 512 -f  ${QBT_PROFILES_DIR}/qBittorrent_${QBT_PROFILE_NAME}/data/logs/* &
exec qbittorrent-nox -d --profile=${QBT_PROFILES_DIR} --configuration=${QBT_PROFILE_NAME} --webui-port=${QBT_PORT_WEBUI}
