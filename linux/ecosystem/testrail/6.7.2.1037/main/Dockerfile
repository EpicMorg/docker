FROM epicmorg/apache2:php7.2

##############################################################################
# Testrail Install
##############################################################################


ARG TESTRAIL_VERSION=6.7.2.1037
ARG DOWNLOAD_URL=https://secure.testrail.com/downloads/testrail/testrail-${TESTRAIL_VERSION}-ion72.zip

ENV TR_DEFAULT_TASK_EXECUTION=60

ENV TESTRAIL_RELEASE_DIR=/testrail-release

ENV TR_WWW_PATH=/var/www/testrail
ENV TR_CONFIGPATH=${TR_CONFIG_DIR}
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

ENV OPENSSL_CONF=/etc/ssl/

RUN apt-get update && \
    apt-get install -y --no-install-recommends zlib1g-dev libcurl4-gnutls-dev libldap2-dev zlib1g-dev libxml2-dev libfontconfig1 && \
    apt-get clean && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /run.sh && \
    rm -rf /tmp/*

RUN echo "[testrail] Preparing folders" && \
    mkdir -p ${TESTRAIL_RELEASE_DIR} && \
    mkdir -p ${TR_WWW_PATH} && \
    mkdir -p ${TR_DEFAULT_ATTACHMENT_DIR} ${TR_DEFAULT_REPORT_DIR} ${TR_DEFAULT_AUDIT_DIR} ${TR_DEFAULT_LOG_DIR} && \
    echo "[testrail] Downloading and installing" && \
    wget --user-agent "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" --no-check-certificate -O ${TESTRAIL_RELEASE_DIR}/testrail.zip ${DOWNLOAD_URL} && \
    chown -R www-data:www-data ${TESTRAIL_RELEASE_DIR} && \
    unzip -q -o ${TESTRAIL_RELEASE_DIR}/testrail.zip -d /var/www/ && \
    chown -R www-data:www-data ${TR_WWW_PATH} && \
    ls -las ${TR_WWW_PATH} && \
    chown -R www-data:www-data ${TR_OPT_PATH} && \
    ls -las ${TR_OPT_PATH}

RUN echo "[testrail] Testrail version is: $(cat ${TR_WWW_PATH}/version.txt)"

COPY apache_testrail.conf ${TESTRAIL_RELEASE_DIR}/apache-conf/000-default.conf

#healthcheck. good practice
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:80/ || exit 1

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

#Final config
WORKDIR /var/www/testrail
EXPOSE 80 443

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
