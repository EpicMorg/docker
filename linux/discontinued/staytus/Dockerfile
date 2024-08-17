FROM ruby:buster
LABEL maintainer="Tim Perry <pimterry@gmail.com>; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

USER root

COPY --from=epicmorg/prod /etc/locale.gen /etc/locale.gen
COPY --from=epicmorg/prod /etc/apt/sources.list /etc/apt/sources.list
COPY --from=epicmorg/prod /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg /etc/apt/trusted.gpg.d/deb-multimedia-keyring.gpg
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    # node as the JS engine for uglifier
    apt-get install -y nodejs git && \
    gem install bundler && \
    rm -rfv /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /opt && \
    git clone https://github.com/adamcooke/staytus.git staytus && \
    cd /opt/staytus && \
    bundle install --deployment --without development:test

# Persists copies of other relevant files (DB config, custom themes). Contents of this are copied
# to the relevant places each time the container is started
VOLUME /opt/staytus/persisted

EXPOSE 5000

ENTRYPOINT /entrypoint.sh