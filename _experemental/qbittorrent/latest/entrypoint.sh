#!/bin/bash

: ${QBT_PROFILES_DIR:=/opt/qbittorrent/profiles}
: ${QBT_PROFILE_NAME:=docker}

: ${SMB_ENABLED:=false}

: ${SMB_DIR:=/mnt/smb}
: ${SMB_IP:=10.10.10.10}
: ${SMB_USER:=admin}
: ${SMB_PASS:=password}
: ${SMB_WORKGROUP:=WORKGROUP}
: ${SMB_BIND:=/remote/folder}

#mounting
case $SMB_ENABLED in
     true)
          echo "SMB Mount enabled - trying to mount"
          mount.cifs //${SMB_IP}${{SMB_BIND} ${SMB_DIR} -o username=${SMB_USER},password=${SMB_PASS},domain=${SMB_WORKGROUP},iocharset=utf8,file_mode=0777,dir_mode=0777,noperm,mapchars
          ;;
     false)
          echo "SMD Disabled - skipping"
          ;;
esac

#starting torrent
qbittorrent-nox --profile=${QBT_PROFILES_DIR} --configuration=${QBT_PROFILE_NAME} --webui-port=8080