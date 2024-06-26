FROM epicmorg/astralinux:1.7-main
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG K_PYTHON_VERSION=3.12.4

##################################################################
#                   update lists
##################################################################
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update

##################################################################
#                   Version before install
##################################################################
RUN echo "=============================================" && \
    echo $(python3 --version) && \
    echo $(pip3 --version) && \
    echo "=============================================" && \
    echo $(python --version) && \
    echo $(pip --version) && \
    echo "============================================="

##################################################################
#                   Install prerequierments to Python compile
##################################################################
RUN apt install -y --allow-unauthenticated \
    automake \
    build-essential \
    gcc \
    g++ \
    cmake \
    dpkg-dev \
    fakeroot \
    libdpkg-perl \
    zlib1g-dev  \
    zlib1g \
    libssl-dev \
    libffi-dev \
    libncurses*-dev \
    libsqlite3-dev \
    libbz2-dev \
    libreadline-dev \
    uuid-dev liblz-dev \
    liblzma-dev lzma-dev \
    liblz-dev \
    libsqlite3-dev \
    libgdbm-dev \
    tk-dev \
    libgdbm-compat-dev

##################################################################
#                   Python compilation
##################################################################
RUN cd /tmp && \
    wget -O /tmp/Python-${K_PYTHON_VERSION}.tgz https://www.python.org/ftp/python/${K_PYTHON_VERSION}/Python-${K_PYTHON_VERSION}.tgz && \
    tar -zxf Python-${K_PYTHON_VERSION}.tgz && \
    cd /tmp/Python-${K_PYTHON_VERSION} && \
    ./configure \
    --enable-optimizations \
    --with-lto \
    --with-system-expat \
    --enable-loadable-sqlite-extensions \
    --enable-profiling \
    --enable-option-checking=fatal \
#     --enable-shared \
    --with-computed-gotos \
    --with-openssl-rpath=auto && \
#   make -j$(nproc) test && \
    make -j$(nproc) && \
    make -j$(nproc) altinstall && \
    ldconfig && \
    rm -rfv /tmp/Python-${K_PYTHON_VERSION} && \
    rm /tmp/Python-${K_PYTHON_VERSION}.tgz

##################################################################
#                   Python Setup
##################################################################
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python3.12 0 && \
    /usr/local/bin/python3.12 -m pip install --upgrade pip && \
    update-alternatives --remove pip3 /usr/local/bin/pip3.12 && \
    sudo ln -sfv /usr/local/bin/pip3.12 /usr/local/bin/pip && \
    rm -rfv /usr/local/bin/pip3 /usr/bin/pip3 && \
    apt install -y python3-pip

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    echo $(python3 --version) && \
    echo $(pip3 --version) && \
    echo "=============================================" && \
    echo $(python --version) && \
    echo $(pip --version) && \
    echo "============================================="

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
