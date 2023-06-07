
FROM epicmorg/nodejs:node19 as nodejs

RUN git clone https://github.com/torrust/torrust-index-frontend.git -b develop /opt/torrust-index-frontend && \
    cd /opt/torrust-index-frontend && \
    echo "VITE_API_BASE_URL=/api" > .env && \
    npm i && \
    npm run build && \
    ls -las && \
    cd ./dist/ && \
    ls -las


FROM epicmorg/debian:bullseye-develop as builder

RUN git clone https://github.com/torrust/torrust-index-backend.git -b develop /opt/torrust-index-backend && \
    cd /opt/torrust-index-backend && \
    echo "DATABASE_URL=sqlite://data.db?mode=rwc" >> .env && \
    cargo install sqlx-cli && \
    sqlx db setup && \
    cargo build --release && \
    ls -las && \
    cd ./target/release/ && \
    mv ./main  ./torrust-index-backend && \
    mv ./upgrade ./torrust-index-upgrade && \
    ls -las

FROM  epicmorg/nginx:latest

ENV TORRUST_PORT=80
ENV TORRUST_DIR=/app
ENV TORRUST_BIN=${TORRUST_DIR}/bin
ENV TORRUST_DATA=${TORRUST_DIR}/data
ENV TORRUST_UPLOADS=${TORRUST_DIR}/uploads
ENV TORRUST_WWW=${TORRUST_DIR}/www

RUN mkdir -p ${TORRUST_DIR} ${TORRUST_BIN} ${TORRUST_DATA} ${TORRUST_UPLOADS} ${TORRUST_WWW}

RUN ln -sf ${TORRUST_DATA}/config.toml ${TORRUST_BIN}/config.toml
RUN ln -sf ${TORRUST_DATA}/data.db ${TORRUST_BIN}/data.db


COPY --from=builder /opt/torrust-index-backend/target/release/torrust-index-backend ${TORRUST_BIN}/torrust-index-backend
COPY --from=builder /opt/torrust-index-backend/target/release/torrust-index-upgrade ${TORRUST_BIN}/torrust-index-upgrade
RUN chmod +x ${TORRUST_BIN}/torrust-index-backend && \
    chmod +x ${TORRUST_BIN}/torrust-index-upgrade

COPY --from=nodejs /opt/torrust-index-frontend/dist/ ${TORRUST_WWW}
RUN tree ${TORRUST_WWW} && \
    chown -R www-data:www-data ${TORRUST_WWW} && \
    ls -las ${TORRUST_WWW}

RUN apt-get update && \
    apt-get -y install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

EXPOSE ${TORRUST_PORT}
EXPOSE ${TORRUST_PORT}/udp

WORKDIR ${TORRUST_DIR}
VOLUME  ${TORRUST_DATA}
VOLUME  ${TORRUST_UPLOADS}


# nginx base configuration
ADD torrust-index.conf /etc/nginx/sites-enabled/torrust-index.conf

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf

# Add image configuration and scripts
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
RUN chmod 755 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["docker-entrypoint.sh"]
