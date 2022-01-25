FROM epicmorg/apache2:php7.4

ARG TESTRAIL_VERSION=latest
ARG DOWNLOAD_URL=https://secure.gurock.com/downloads/testrail/testrail-${TESTRAIL_VERSION}-ion72.zip
ARG TESTRAIL_RELEASE_DIR=testrail-release

ENV TR_DEFAULT_TASK_EXECUTION=60
ENV TR_WWWPATH="/var/www/testrail/"
ENV TR_CONFIGPATH="/var/www/testrail/config/"
ENV TR_CUSTOM_DIR="/var/www/testrail/custom/"
ENV TR_CUSTOM_AUTH_DIR="/var/www/testrail/custom/auth/"

ENV TR_OPTPATH="/opt/testrail/"
ENV TR_DEFAULT_LOG_DIR="/opt/testrail/logs/"
ENV TR_DEFAULT_AUDIT_DIR="/opt/testrail/audit/"
ENV TR_DEFAULT_REPORT_DIR="/opt/testrail/reports/"
ENV TR_DEFAULT_ATTACHMENT_DIR="/opt/testrail/attachments/"
ENV OPENSSL_CONF=/etc/ssl/

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends zlib1g-dev libcurl4-gnutls-dev libldap2-dev zlib1g-dev libxml2-dev libfontconfig1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /run.sh


RUN \
  echo "WGET" && \
  mkdir -p /${TESTRAIL_RELEASE_DIR} && \
  mkdir -p /var/www/testrail && \
  mkdir -p /opt/testrail/attachments /opt/testrail/reports /opt/testrail/logs /opt/testrail/audit && \
  wget --no-check-certificate -O /${TESTRAIL_RELEASE_DIR}/testrail.zip ${DOWNLOAD_URL} && \
  chown -R www-data:www-data /${TESTRAIL_RELEASE_DIR} && \
  unzip -o /testrail-release/testrail.zip -d /var/www/ && \
  ls -las /var/www/testrail && \
  chown -R www-data:www-data /var/www/testrail && \
  chown -R www-data:www-data /opt/testrail


COPY apache_testrail.conf /${TESTRAIL_RELEASE_DIR}/apache-conf/000-default.conf
COPY run.sh /run.sh

WORKDIR /var/www/testrail
EXPOSE 80

CMD ["/run.sh"]
