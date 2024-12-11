#!/bin/bash

echo "[testrail] Welcome to Testrail 8.0.4.7036 with LDAP plugin"

echo "[testrail] Starting testrail service"

#################################################################################

function createOptDirectory {
    if [ ! -d $1 ]
    then
        echo "[testrail] Creating " $1
        mkdir -p $1
    fi

    chown -R www-data:www-data $1
}

/bin/cp -rf ${TESTRAIL_RELEASE_DIR}/apache-conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf

echo "[testrail] Unzipping testrail service"
unzip -q -o ${TESTRAIL_RELEASE_DIR}/testrail.zip -d /var/www/

echo "[testrail] Unzipping testrail LDAP auth plugin"
unzip -q -o -j ${TESTRAIL_RELEASE_DIR}/${TESTRAIL_PLUGIN_FILE} ${TESTRAIL_PLUGIN_FULLNAME}/auth.php -d ${TR_CUSTOM_AUTH_DIR}

createOptDirectory ${TR_DEFAULT_LOG_DIR}
createOptDirectory ${TR_DEFAULT_AUDIT_DIR}
createOptDirectory ${TR_DEFAULT_REPORT_DIR}
createOptDirectory ${TR_DEFAULT_ATTACHMENT_DIR}

chown -R www-data:www-data ${TR_CONFIG_DIR}

#################################################################################

echo "[testrail] Waiting for background task file"
while [ ! -f /var/www/testrail/task.php ]
do
  sleep 2
done

echo "[testrail] Starting background task"
while /bin/true; do
    php /var/www/testrail/task.php || true
    sleep ${TR_DEFAULT_TASK_EXECUTION}
done &
echo "[testrail] Background task stoped"

#################################################################################

if [[ -z "${FIX_WWW_DATA}" ]]; then
  echo "[apache2] env FIX_WWW_DATA is not set. Fixing permissions anyway"
  chown www-data:www-data /var/www -R
elif [ "${FIX_WWW_DATA}" == "false" ]; then
  echo "[apache2] env FIX_WWW_DATA is set to false. Skipping..."
elif  [ "${FIX_WWW_DATA}" == "true" ]; then
  echo "[apache2] Changing permissions for /var/www path. Dont worry, please wait."
  chown www-data:www-data /var/www -R
  echo "[apache2] Done"
else
  echo "[apache2] env FIX_WWW_DATA is set to strange value. Skipping..."
fi

echo "[apache2] Starting up"

source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
