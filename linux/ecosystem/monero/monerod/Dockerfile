FROM epicmorg/debian:bullseye
LABEL maintainer="original by sethforprivacy; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV MONERO_DIR=/monero
ENV MONERO_BIN=${MONERO_DIR}/bin
ENV MONERO_DATA=${MONERO_DIR}/data
ENV MONERO_VERSION=0.18.1.0
ENV MONERO_DOWNLOAD_URL=https://downloads.getmonero.org/cli/monero-linux-x64-v${MONERO_VERSION}.tar.bz2
ENV PATH="${PATH}:${MONERO_BIN}"

##################################################################
#                   Installing
##################################################################
RUN mkdir /monero /monero/bin /monero/data

RUN apt-get update && \
    apt-get install -y \
    libzmq3-dev

RUN echo ${MONERO_BIN}
RUN wget -qO-  ${MONERO_DOWNLOAD_URL} | tar -xvj --strip-components=1 -C ${MONERO_BIN}

RUN export PATH="${PATH}:${MONERO_BIN}"

RUN monerod --version

# Expose p2p port
EXPOSE 18080

# Expose restricted RPC port
EXPOSE 18089

VOLUME ["${MONERO_DATA}"]
WORKDIR ${MONERO_DIR}

# Add HEALTHCHECK against get_info endpoint
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://localhost:18081/get_info || exit 1

# Copy and enable entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN set -ex && chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# Start monerod with sane defaults that are overridden by user input (if applicable)
CMD ["--rpc-restricted-bind-ip=0.0.0.0", "--rpc-restricted-bind-port=18089", "--no-igd", "--no-zmq", "--enable-dns-blocklist"]
