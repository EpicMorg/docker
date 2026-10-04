FROM docker.io/epicmorg/debian:trixie-develop-light
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
# /etc/ld.so.conf.d/
ARG LD_CONF_DIR=/etc/ld.so.conf.d/


# llvm-mingw
ENV LLVM_MINGW_VERSION=20260826
ENV LLVM_MINGW_DIR=${EMG_LOCAL_BASE_DIR}/llvm-mingw/${LLVM_MINGW_VERSION}
ARG LLVM_MINGW_DOWNLOAD_URL=https://github.com/mstorsjo/llvm-mingw/releases/download/${LLVM_MINGW_VERSION}

# GO source tarball
ENV GO_MIN_VERSION=1.26
ENV GO_VERSION=${GO_MIN_VERSION}.8
ENV GO_DIR=${EMG_LOCAL_BASE_DIR}/go/${GO_MIN_VERSION}
ARG GO_BIN_DIR=${GO_DIR}/bin
ARG GO_PATH_DIR=${GO_DIR}/gopath
ARG GO_PATH_BIN_DIR=${GO_PATH_DIR}/bin
ARG GO_DOWNLOAD_URL=https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
ARG GO_TEMP=/tmp/go${GO_VERSION}.linux-amd64.tar.gz

##################################################################
#                   llvm-mingw
##################################################################
RUN set -eux; \
    mkdir -p ${LLVM_MINGW_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-i686.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-i686.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-x86_64.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-x86_64.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-x86_64.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-x86_64.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-aarch64.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-aarch64.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-armv7.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-armv7.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-i686.zip \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-i686.zip" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-ubuntu-22.04-x86_64.tar.xz \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-ubuntu-22.04-x86_64.tar.xz" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-macos-universal.tar.xz \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-macos-universal.tar.xz" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-aarch64.tar.xz \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-aarch64.tar.xz" && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d / \
        -o /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz \
        "${LLVM_MINGW_DOWNLOAD_URL}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz" && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-i686.zip -d ${LLVM_MINGW_DIR} && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-x86_64.zip -d ${LLVM_MINGW_DIR} && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-x86_64.zip -d ${LLVM_MINGW_DIR} && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-aarch64.zip -d ${LLVM_MINGW_DIR} && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-armv7.zip -d ${LLVM_MINGW_DIR} && \
    unzip -q /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-i686.zip -d ${LLVM_MINGW_DIR} && \
    tar -xf /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-msvcrt-ubuntu-22.04-x86_64.tar.xz --directory ${LLVM_MINGW_DIR} && \
    tar -xf /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-macos-universal.tar.xz --directory ${LLVM_MINGW_DIR} && \
    tar -xf /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-aarch64.tar.xz --directory ${LLVM_MINGW_DIR} && \
    tar -xf /tmp/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-ubuntu-22.04-x86_64.tar.xz --directory ${LLVM_MINGW_DIR} && \
    echo "clean up" && \
    rm -rfv /tmp/*

##################################################################
#                   GO compillers
##################################################################
RUN set -eux; \
    mkdir -p ${GO_DIR} ${GO_PATH_BIN_DIR} ${GO_BIN_DIR} && \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${GO_DOWNLOAD_URL}" && \
    tar -xzf ${GO_TEMP} --directory ${GO_DIR} --strip-components=1 && \
    chmod +x ${GO_BIN_DIR}/go && \
    chmod +x ${GO_BIN_DIR}/gofmt && \
    echo "clean up" && \
    rm -rfv /tmp/*

ENV GOROOT=${GO_DIR}
ENV GOPATH=${GO_PATH_DIR}
ENV PATH="${GO_BIN_DIR}:${GO_PATH_BIN_DIR}:${PATH}"

RUN echo "=============================================" && \
    echo $(go version) && \
    echo "============================================="

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(lsb_release -d) && \
    echo "Version: $(cat /etc/debian_version)" && \
    echo "============================================="

##################################################################
#                   other   customisations
##################################################################
