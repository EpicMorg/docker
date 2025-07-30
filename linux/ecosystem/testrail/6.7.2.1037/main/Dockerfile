FROM epicmorg/apache2:php7.2

##############################################################################
# Testrail Install
##############################################################################


ENV TESTRAIL_VERSION=6.7.2.1037
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

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

#RUN mkdir -p ${TESTRAIL_RELEASE_DIR} && \
#    wget -c \
#    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:128.0) Gecko/20100101 Firefox/128.0" \
#    --no-check-certificate \
#    --retry-connrefused \
#    --tries=15 \
#    --timeout=30 \
#    --waitretry=15 \
#    --dns-timeout=30 \
#    --read-timeout=30 \
#    --progress=dot:giga \
#    --no-clobber \
#    -O ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}-ion72.zip \
#    "${DOWNLOAD_URL}"

ADD ${DOWNLOAD_URL} ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}-ion72.zip
RUN echo "[testrail] Preparing folders" && \
    mkdir -p ${TR_WWW_PATH} && \
    mkdir -p ${TR_DEFAULT_ATTACHMENT_DIR} ${TR_DEFAULT_REPORT_DIR} ${TR_DEFAULT_AUDIT_DIR} ${TR_DEFAULT_LOG_DIR} && \
    echo "[testrail] Downloading and installing" && \
    chown -R www-data:www-data ${TESTRAIL_RELEASE_DIR} && \
    unzip -q -o ${TESTRAIL_RELEASE_DIR}/testrail-${TESTRAIL_VERSION}-ion72.zip -d /var/www/ && \
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
