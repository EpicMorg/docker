FROM ghcr.io/epicmorg/apache2:php5.5
LABEL org.opencontainers.image.title="EpicMorg TestRail"
LABEL org.opencontainers.image.description="TestRail 4.2.0.3315 on Apache2 + PHP 5.5 (fpm) by EpicMorg"
ARG DEBIAN_FRONTEND=noninteractive

##############################################################################
# Testrail Install
##############################################################################
ENV TESTRAIL_VERSION=4.2.0.3315
ENV TESTRAIL_ION=ion53
ARG DOWNLOAD_URL=https://secure.testrail.com/downloads/testrail/testrail-${TESTRAIL_VERSION}-${TESTRAIL_ION}.zip

ENV TR_DEFAULT_TASK_EXECUTION=60

ENV TESTRAIL_RELEASE_DIR=/testrail-release

ENV TR_WWW_PATH=/var/www/testrail
ENV TR_CONFIG_DIR=${TR_WWW_PATH}/config
ENV TR_CUSTOM_DIR=${TR_WWW_PATH}/custom
ENV TR_CUSTOM_AUTH_DIR=${TR_CUSTOM_DIR}/auth

ENV TR_OPT_PATH=/opt/testrail
ENV TR_DEFAULT_LOG_DIR=${TR_OPT_PATH}/logs
ENV TR_DEFAULT_AUDIT_DIR=${TR_OPT_PATH}/audit
ENV TR_DEFAULT_REPORT_DIR=${TR_OPT_PATH}/reports
ENV TR_DEFAULT_ATTACHMENT_DIR=${TR_OPT_PATH}/attachments

ENV TR_OPTPATH="/opt/testrail/"
ENV TR_CONFIGPATH="/var/www/testrail/config/"

##################################################################
#                    Shared wget args
##################################################################
ARG WGET_ARGS="--continue \
  --quiet \
  --no-check-certificate \
  --retry-connrefused \
  --tries=15 \
  --timeout=30 \
  --waitretry=15 \
  --dns-timeout=30 \
  --connect-timeout=30 \
  --read-timeout=30 \
  --no-clobber"

ARG WGET_USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0"

##################################################################
#                   Installing
##################################################################
# The zip stays in TESTRAIL_RELEASE_DIR: the entrypoint re-extracts it on every
# start, so a /var/www volume always carries the code of this image.
RUN set -eux; \
    mkdir -p ${TESTRAIL_RELEASE_DIR} ${TR_WWW_PATH}; \
    mkdir -p ${TR_DEFAULT_ATTACHMENT_DIR} ${TR_DEFAULT_REPORT_DIR} ${TR_DEFAULT_AUDIT_DIR} ${TR_DEFAULT_LOG_DIR}; \
    echo "[testrail] Downloading ${DOWNLOAD_URL}"; \
    wget ${WGET_ARGS} --user-agent "${WGET_USER_AGENT}" -O ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip ${DOWNLOAD_URL}; \
    unzip -tq ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip; \
    unzip -q -o ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}.zip -d /var/www/; \
    test -f ${TR_WWW_PATH}/index.php; \
    mkdir -p ${TR_CONFIG_DIR} ${TR_CUSTOM_AUTH_DIR}; \
    chown -R www-data:www-data ${TESTRAIL_RELEASE_DIR} ${TR_WWW_PATH} ${TR_OPT_PATH}; \
    echo "[testrail] Testrail version is: $(cat ${TR_WWW_PATH}/version.txt 2>/dev/null || echo ${TESTRAIL_VERSION})"

##################################################################
#                   PHP checks
##################################################################
# ionCube loader and the extensions come from the epicmorg/php base image.
# TestRail is ionCube-encoded for PHP 5.3+ (ion53 package).
RUN set -eux; \
    php -v; \
    php -v | grep -qi 'ionCube' || { echo "FATAL: ionCube loader not active" >&2; exit 1; }; \
    grep -rqE '^listen *= */run/php/php-fpm.sock' ${PHP_INI_DIR}/php-fpm.d/ \
      || { echo "FATAL: php-fpm does not listen on /run/php/php-fpm.sock (apache2 base expects the unix socket)" >&2; exit 1; }; \
    for ext in curl json mbstring mysqli pdo_mysql openssl zip gd xml session zlib; do \
      php -m | grep -qix "${ext}" || { echo "FATAL: php extension ${ext} missing" >&2; php -m >&2; exit 1; }; \
    done

##################################################################
#                   Apache2 + supervisor
##################################################################
COPY etc/apache2/    /etc/apache2/
COPY etc/supervisor/ /etc/supervisor/
COPY usr/local/bin/testrail-entrypoint.sh /usr/local/bin/testrail-entrypoint.sh
COPY usr/local/bin/testrail-task.sh       /usr/local/bin/testrail-task.sh

RUN set -eux; \
    chmod 755 /usr/local/bin/testrail-entrypoint.sh /usr/local/bin/testrail-task.sh; \
    a2dissite localhost; \
    a2ensite testrail; \
    apachectl configtest

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s --start-period=30s \
        CMD curl -fsS -o /dev/null http://localhost/ || exit 1

#Final config
WORKDIR ${TR_WWW_PATH}
EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/testrail-entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
