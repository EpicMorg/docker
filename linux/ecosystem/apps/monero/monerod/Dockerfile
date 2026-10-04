FROM docker.io/epicmorg/debian:trixie
LABEL maintainer="original by sethforprivacy; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV MONERO_DIR=/monero
ENV MONERO_BIN=${MONERO_DIR}/bin
ENV MONERO_DATA=${MONERO_DIR}/data
ENV MONERO_VERSION=0.18.5.1
# https://www.getmonero.org/downloads/hashes.txt
ARG MONERO_SHA256=22a7dda7b0cb699fdd6b7674c3b4a4465b337cc98a54983523b759e1e7cc9958
ENV MONERO_DOWNLOAD_URL=https://downloads.getmonero.org/cli/monero-linux-x64-v${MONERO_VERSION}.tar.bz2
ENV PATH="${PATH}:${MONERO_BIN}"

##################################################################
#                   Installing
##################################################################
RUN mkdir ${MONERO_DIR} ${MONERO_BIN} ${MONERO_DATA}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libzmq3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    wget -q -O /tmp/monero.tar.bz2 "${MONERO_DOWNLOAD_URL}"; \
    echo "${MONERO_SHA256}  /tmp/monero.tar.bz2" | sha256sum -c -; \
    tar -xjf /tmp/monero.tar.bz2 --strip-components=1 -C "${MONERO_BIN}"; \
    rm -f /tmp/monero.tar.bz2; \
    monerod --version | grep -q "v${MONERO_VERSION}" || { echo "FATAL: monerod is not ${MONERO_VERSION}" >&2; monerod --version >&2; exit 1; }

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

