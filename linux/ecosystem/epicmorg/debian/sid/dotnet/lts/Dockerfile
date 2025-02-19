FROM epicmorg/debian:sid-develop  as builder
RUN echo "Just temp lyer to copy OpenSSL"

FROM epicmorg/debian:sid
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV DOTNET_CHANNEL=LTS
ENV DOTNET_ROOT=${EMG_LOCAL_BASE_DIR}/dotnet/${DOTNET_CHANNEL}
ARG DOTNET_TOOLS_DIR=${DOTNET_ROOT}/tools
ARG DOTNET_INSTALL_DIR=${DOTNET_ROOT}
ARG DOTNET_INSTALL_SCRIPT_URL=https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

ENV DOTNET_CLI_TELEMETRY_OPTOUT=true
ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

##################################################################
#                  OpenSSL 3.4
##################################################################
ENV OPENSSL_34_VERSION=3.4.1
ENV OPENSSL_34_DIR=${EMG_LOCAL_BASE_DIR}/openssl/${OPENSSL_34_VERSION}
ENV OPENSSL_34_BIN_DIR=${OPENSSL_34_DIR}/bin
ENV OPENSSL_34_INC_DIR=${OPENSSL_34_DIR}/include
ENV OPENSSL_34_LIB_DIR=${OPENSSL_34_DIR}/lib64
ENV OPENSSL_34_SRC_DIR=/usr/local/src/openssl/${OPENSSL_34_VERSION}

COPY --from=builder ${OPENSSL_34_DIR} ${OPENSSL_34_DIR}
COPY --from=builder ${OPENSSL_34_SRC_DIR} ${OPENSSL_34_SRC_DIR}

ENV OPENSSL_ROOT=${OPENSSL_34_DIR}
ENV LD_LIBRARY_PATH=${OPENSSL_ROOT}/lib64:$LD_LIBRARY_PATH

##################################################################
#                   installing dotnet
##################################################################
ADD ${DOTNET_INSTALL_SCRIPT_URL} /tmp
RUN mkdir -p ${DOTNET_ROOT} && \ 
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --verbose --no-path --install-dir ${DOTNET_ROOT} --channel ${DOTNET_CHANNEL} --version latest

##################################################################
#                   Setup $PATH
##################################################################
ENV PATH=$PATH:${DOTNET_ROOT}:${DOTNET_TOOLS_DIR}:${OPENSSL_34_BIN_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(dotnet --info) && \
    echo $(dotnet --list-sdks) && \
    echo $(dotnet --list-runtimes) && \
    echo "============================================="

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
