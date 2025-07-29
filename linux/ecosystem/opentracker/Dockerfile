FROM epicmorg/debian:trixie-develop as compile-stage
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /usr/src

##################################################################
# Run libowfat compilation in separated layer to benefit from docker layer cache
##################################################################
RUN cvs -d :pserver:cvs@cvs.fefe.de:/cvs -z9 co libowfat ; \
    git clone git://erdgeist.org/opentracker ; \
    cd /usr/src/libowfat ; \
    make

##################################################################
# http://erdgeist.org/arts/software/opentracker/#build-instructions
##################################################################
RUN cd /usr/src/opentracker ; \
      # Build opentracker statically to use it in scratch image
      LDFLAGS=-static make ; \
      mkdir -pv /tmp/stage/bin ; \
      install -m 755 opentracker.debug /tmp/stage/bin ; \
      make DESTDIR=/tmp/stage BINDIR="/bin" install

FROM epicmorg/debian:trixie

##################################################################
#                   setup future environment
##################################################################
ENV APP_DIR=/etc/opentracker

ENV RETRACKER_BIN=opentracker
ENV RETRACKER_PORT=6969
ENV RETRACKER_CONFIG=/etc/opentracker/opentracker.conf
ENV RETRACKER_DEBUG=false
ENV RETRACKER_OPTS=

WORKDIR ${APP_DIR}

RUN mkdir -pv ${APP_DIR}

COPY --from=compile-stage /tmp/stage/bin /usr/bin
COPY etc/opentracker/ ${APP_DIR}

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/mc.patch && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/* && \
    rm -rfv ${APP_API_DIR}/phpcs.xml && \
    rm -rfv ${APP_API_DIR}/composer.lock && \
    rm -rfv ${APP_API_DIR}/composer.json

##################################################################
#                   healthcheck. good practice
##################################################################
HEALTHCHECK --interval=2m --timeout=3s CMD curl -f http://localhost:${RETRACKER_PORT}/ || exit 1

##################################################################
#                   Add image configuration and scripts
##################################################################
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

##################################################################
#                   Final config
##################################################################
EXPOSE ${RETRACKER_PORT}/udp
EXPOSE ${RETRACKER_PORT}/tcp

##################################################################
#                   volumes for logs and data
##################################################################


##################################################################
#                   Setup stopsignal
##################################################################
STOPSIGNAL SIGINT

##################################################################
#                   run site
##################################################################
ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
