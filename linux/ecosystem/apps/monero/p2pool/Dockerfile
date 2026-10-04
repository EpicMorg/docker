FROM docker.io/epicmorg/debian:trixie
LABEL maintainer="original by sethforprivacy; EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive


##################################################################
#                   ARGuments
##################################################################
ENV P2POOL_DIR=/p2pool
ENV P2POOL_VERSION=4.18.1
# GitHub release asset digest
ARG P2POOL_SHA256=eeab5aca0edf4756cb295c5fda5b2d5344208aecbbdcb2ffd8471dfe14e6c2c5
ENV P2POOL_DOWNLOAD_URL=https://github.com/SChernykh/p2pool/releases/download/v${P2POOL_VERSION}/p2pool-v${P2POOL_VERSION}-linux-x64.tar.gz

##################################################################
#                   Installing
##################################################################
RUN mkdir -p ${P2POOL_DIR}

# Install remaining dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y libuv1-dev libzmq3-dev libsodium-dev \
    libpgm-dev libnorm-dev libgss-dev libcurl4-openssl-dev libidn2-0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    wget -q -O /tmp/p2pool.tar.gz "${P2POOL_DOWNLOAD_URL}"; \
    echo "${P2POOL_SHA256}  /tmp/p2pool.tar.gz" | sha256sum -c -; \
    tar -xzf /tmp/p2pool.tar.gz --strip-components=1 -C /tmp p2pool-v${P2POOL_VERSION}-linux-x64/p2pool; \
    install -m 0755 /tmp/p2pool /usr/local/bin/p2pool; \
    rm -f /tmp/p2pool /tmp/p2pool.tar.gz; \
    p2pool --help >/dev/null

# Switch to home directory and install newly built p2pool binary
WORKDIR ${P2POOL_DIR}

# Expose p2p and restricted RPC ports
EXPOSE 3333
EXPOSE 37889
EXPOSE 37888

# Start p2pool with sane defaults; arguments given to `docker run` / compose `command`
# replace CMD entirely, so pass at least --host <monerod> and --wallet <address>.
# Each flag and its value are separate exec-form words (one string = one argv entry).
ENTRYPOINT ["p2pool"]
CMD ["--host", "monerod", "--stratum", "0.0.0.0:3333", "--p2p", "0.0.0.0:37889", "--addpeers", "65.21.227.114:37889,node.sethforprivacy.com:37889"]
