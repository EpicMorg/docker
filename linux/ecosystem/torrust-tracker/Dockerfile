FROM hub.epicm.org/epicmorg/debian:bullseye-develop as builder


RUN git clone https://github.com/torrust/torrust-tracker.git -b develop /opt/torrust-tracker && \
    cd /opt/torrust-tracker && \
    cargo build --release && \
    ls -las && \
    cd ./target/release/ && \
    ls -las


FROM  epicmorg/debian:bullseye

ARG TORRUST_PORT=1337
ARG TORRUST_ADMIN=1488
ENV TORRUST_DIR=/app
ENV TORRUST_DATA=${TORRUST_DIR}/data

RUN mkdir -p ${TORRUST_DIR} ${TORRUST_DATA}

RUN ln -sf ${TORRUST_DATA}/config.toml ${TORRUST_DIR}/config.toml
RUN ln -sf ${TORRUST_DATA}/data.db ${TORRUST_DIR}/data.db

COPY --from=builder /opt/torrust-tracker/target/release/torrust-tracker ${TORRUST_DIR}/torrust-tracker
RUN chmod 755 ${TORRUST_DIR}/torrust-tracker

EXPOSE ${TORRUST_PORT}
EXPOSE ${TORRUST_PORT}/udp
EXPOSE ${TORRUST_ADMIN}

WORKDIR ${TORRUST_DIR}
VOLUME  ${TORRUST_DATA}

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

RUN updatedb

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
