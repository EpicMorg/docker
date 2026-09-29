#!/bin/bash
# TestRail init: refresh the application code (so a /var/www volume gets the
# image's version), prepare data dirs, then hand over to CMD (supervisord:
# php-fpm + apache2 + testrail-task).

set -e

echo "[testrail] Welcome to TestRail ${TESTRAIL_VERSION}"

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
# Unpacking TestRail
TESTRAIL_ZIP="${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip"
if [ -f "${TESTRAIL_ZIP}" ]; then
    echo "[testrail] Unzipping ${TESTRAIL_ZIP}"
    unzip -q -o "${TESTRAIL_ZIP}" -d /var/www/
    chown -R www-data:www-data "${TR_WWW_PATH}"
    echo "[testrail] TestRail extracted"
else
    echo "[testrail] Error: ${TESTRAIL_ZIP} not found"
    exit 1
fi

#################################################################################
# Creating the necessary directories
createOptDirectory "${TR_DEFAULT_LOG_DIR}"
createOptDirectory "${TR_DEFAULT_AUDIT_DIR}"
createOptDirectory "${TR_DEFAULT_REPORT_DIR}"
createOptDirectory "${TR_DEFAULT_ATTACHMENT_DIR}"
createOptDirectory "${TR_CONFIG_DIR}"

#################################################################################
# FIX_WWW_DATA (whole /var/www) is handled by the apache2 launcher of the base image.

exec "$@"
