#!/bin/bash

if [[ -z "${FIX_WWW_DATA}" ]]; then
  echo "[nginx] env FIX_WWW_DATA is not set. Skipping..."
elif [ "${FIX_WWW_DATA}" == "false" ]; then
  echo "[nginx] env FIX_WWW_DATA is set to false. Skipping..."
elif  [ "${FIX_WWW_DATA}" == "true" ]; then
  echo "[nginx] Changing permissions for /var/www path. Dont worry, please wait."
  chown www-data:www-data /var/www -R
  echo "[nginx] Done"
else
  echo "[nginx] env FIX_WWW_DATA is set to strange value. Skipping..."
fi

echo "[nginx] Starting up"
nginx -g 'daemon off;'
