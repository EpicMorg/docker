#!/bin/bash

echo "[testrail] Welcome to Testrail 8.0.1.1029 with Active Directory plugin"

echo "[testrail] Starting testrail service"

#################################################################################
# Function for creating directories with rights for www-data
function createOptDirectory {
    if [ ! -d "$1" ]; then
        echo "[testrail] Creating $1"
        mkdir -p "$1"
    fi

    chown -R www-data:www-data "$1"
}

#################################################################################
# Copy Apache Configuration
/bin/cp -rf "${TESTRAIL_RELEASE_DIR}/apache-conf/000-default.conf" "/etc/apache2/sites-enabled/000-default.conf"

#################################################################################
# Unpacking TestRail
if [ -f "${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}-ion70.zip" ]; then
    echo "[testrail] Unzipping testrail service"
    unzip -q -o "${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}-ion70.zip" -d /var/www/
    echo "[testrail] Testrail extracted"
else
    echo "[testrail] Error: testrail-${TESTRAIL_VERSION}-ion70.zip not found in ${TESTRAIL_RELEASE_DIR}"
    exit 1
fi

#################################################################################
# Creating the necessary directories
createOptDirectory "${TR_DEFAULT_LOG_DIR}"
createOptDirectory "${TR_DEFAULT_AUDIT_DIR}"
createOptDirectory "${TR_DEFAULT_REPORT_DIR}"
createOptDirectory "${TR_DEFAULT_ATTACHMENT_DIR}"

chown -R www-data:www-data "${TR_CONFIG_DIR}"
chown -R www-data:www-data "${TR_CONFIGPATH}"

#################################################################################
# Waiting for task.php file to appear
TASK_FILE="/var/www/testrail/task.php"
echo "[testrail] Waiting for background task file"
while [ ! -f "$TASK_FILE" ]; do
    sleep 2
done

echo "[testrail] Starting background task"
# Removing the memory limit for executing a PHP task
while /bin/true; do
    php -d memory_limit=-1 "$TASK_FILE" || true
    sleep "${TR_DEFAULT_TASK_EXECUTION:-60}"
done &

echo "[testrail] Background task started"

#################################################################################
# Processing the FIX_WWW_DATA environment variable
if [[ -z "${FIX_WWW_DATA}" ]]; then
    echo "[apache2] env FIX_WWW_DATA is not set. Fixing permissions anyway"
    chown www-data:www-data /var/www -R
elif [ "${FIX_WWW_DATA}" == "false" ]; then
    echo "[apache2] env FIX_WWW_DATA is set to false. Skipping..."
elif [ "${FIX_WWW_DATA}" == "true" ]; then
    echo "[apache2] Changing permissions for /var/www path. Don't worry, please wait."
    chown www-data:www-data /var/www -R
    echo "[apache2] Done"
else
    echo "[apache2] env FIX_WWW_DATA is set to strange value. Skipping..."
fi

#################################################################################
# Starting Apache
echo "[apache2] Starting up"
source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
