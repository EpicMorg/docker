FROM epicmorg/websites:php7.2

ARG ARG_URL=https://secure.gurock.com/downloads/testrail/testrail-latest-ion71.zip

ENV TR_DEFAULT_TASK_EXECUTION=60
ENV TR_CONFIGPATH="/opt/www/testrail/config/"
ENV TR_DEFAULT_LOG_DIR="/opt/testrail/logs/"
ENV TR_DEFAULT_AUDIT_DIR="/opt/testrail/audit/"
ENV TR_DEFAULT_REPORT_DIR="/opt/testrail/reports/"
ENV TR_DEFAULT_ATTACHMENT_DIR="/opt/testrail/attachments/"
ENV OPENSSL_CONF=/etc/ssl/

LABEL vendor="TestRail" \
      maintainer="Christian Breitwieser" \
      email="cbreitwieser@ranorex.com" \
      type="TestRail php-fpm apache image including ionCube loader." \
      description="This is an image which runs apache php-fpm with ionCube for testrail."

RUN wget --no-check-certificate -O /tmp/testrail.zip ${ARG_URL} && \
    mkdir -p /var/www/testrail && \
    mkdir -p /opt/testrail/attachments /opt/testrail/reports /opt/testrail/logs /opt/testrail/audit /opt/www/testrail && \
    unzip /tmp/testrail.zip -d /opt/www/ && \
    rm /tmp/testrail.zip && \
    chown -R www-data:www-data /opt/www/testrail && \
    chown -R www-data:www-data /opt/testrail

RUN echo "opcache.enable=1" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.enable=1" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.enable=1" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.enable=1" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.enable_cli=0" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.enable_cli=0" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.enable_cli=0" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.enable_cli=0" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.max_accelerated_files=10000" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.max_accelerated_files=10000" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.max_accelerated_files=10000" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.max_accelerated_files=10000" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.memory_consumption=128" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.memory_consumption=128" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.memory_consumption=128" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.memory_consumption=128" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.max_wasted_percentage=10" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.max_wasted_percentage=10" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.max_wasted_percentage=10" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.max_wasted_percentage=10" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.save_comments=1" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.save_comments=1" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.save_comments=1" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.save_comments=1" >> /etc/php/7.2/fpm/php.ini && \
    echo "opcache.validate_timestamps=0" >> /etc/php/7.2/apache2/php.ini && \
    echo "opcache.validate_timestamps=0" >> /etc/php/7.2/cgi/php.ini && \
    echo "opcache.validate_timestamps=0" >> /etc/php/7.2/cli/php.ini && \
    echo "opcache.validate_timestamps=0" >> /etc/php/7.2/fpm/php.ini && \
    echo ";opcache.revalidate_freq=16" >> /etc/php/7.2/apache2/php.ini && \
    echo ";opcache.revalidate_freq=16" >> /etc/php/7.2/cgi/php.ini && \
    echo ";opcache.revalidate_freq=16" >> /etc/php/7.2/cli/php.ini && \
    echo ";opcache.revalidate_freq=16" >> /etc/php/7.2/fpm/php.ini && \
    php -v

COPY testrail.conf /etc/apache2/sites-enabled/testrail.conf

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt autoclean -y && \
    rm -rfv /etc/apache2/sites-enabled/000-default.conf && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/ioncube.tar.gz

#volumes
#VOLUME ["/var/www/"]

# Add image configuration and scripts
COPY run.sh /run.sh
RUN chmod 755 /*.sh

# Configure application
EXPOSE 80
WORKDIR /opt//www/testrail
CMD ["/run.sh"]
