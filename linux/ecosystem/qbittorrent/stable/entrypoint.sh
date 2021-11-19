#!/bin/bash

: ${QBT_PROFILES_DIR:=/opt/qbittorrent/profiles}
: ${QBT_PROFILE_NAME:=docker}

export LC_ALL=ru_RU.UTF-8

echo "Starting qBitTorrent..."
qbittorrent-nox --profile=${QBT_PROFILES_DIR} --configuration=${QBT_PROFILE_NAME} --webui-port=8282