FROM epicmorg/debian:bullseye-develop as builder


RUN git clone https://github.com/torrust/torrust-tracker.git /opt/torrust-tracker && \
    cd /opt/torrust-tracker && \
    cargo build --release && \
    ls -las && \
    cd ./target/release/ && \
    ls -las


FROM  epicmorg/debian:bullseye

ENV TRACKER_PORT=1337
ENV TRACKER_ADMIN=1488
ENV TRACKER_DIR=/app
ENV TRACKER_DATA=${TRACKER_DIR}/data

RUN mkdir -p ${TRACKER_DIR} ${TRACKER_DATA}

RUN ln -sf ${TRACKER_DATA}/config.toml ${TRACKER_DIR}/config.toml
RUN ln -sf ${TRACKER_DATA}/data.db ${TRACKER_DIR}/data.db

COPY --from=builder /opt/torrust-tracker/target/release/torrust-tracker ${TRACKER_DIR}/torrust-tracker
RUN chmod 755 ${TRACKER_DIR}/torrust-tracker

EXPOSE ${TRACKER_PORT}
EXPOSE ${TRACKER_PORT}/udp
EXPOSE ${TRACKER_ADMIN}

WORKDIR ${TRACKER_DIR}
VOLUME  ${TRACKER_DATA}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
