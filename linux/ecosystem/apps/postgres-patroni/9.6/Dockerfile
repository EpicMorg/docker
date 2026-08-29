# useful info: https://habr.com/ru/companies/tantor/articles/957790/
# https://github.com/mmartinello/patroni-docker/blob/master/Dockerfile

ARG PG_VERSION=9.6
FROM docker.io/epicmorg/postgres:${PG_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG PATRONI_VERSION=4.1.*
#0.7-3~deb13u1
#ENV PATRONI_VERSION=${PATRONI_VERSION}

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

# Set the package manager and installation commands based on the distro
RUN   apt update -q && \
      apt install -y \
        #patroni=${PATRONI_VERSION} \
        #python3-psycopg2 \
        #python3-etcd3 \
        python3-pip \
        htop \
        net-tools \
        build-essential \
        libpq-dev \
        tini && \
    # pip works!    
    pip install patroni[psycopg2,etcd]==$PATRONI_VERSION --break-system-packages && \
    # cleanup
    apt-get remove --purge -y \
        build-essential \
        libpq-dev && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    chmod 755 /usr/bin/docker-entrypoint.sh && \
    mkdir -p /var/lib/postgresql && \
    chown postgres:postgres /var/lib/postgresql && \
    chmod 700 /var/lib/postgresql

#USER postgres
WORKDIR /

#ENTRYPOINT ["patroni"]
#CMD [ "/etc/patroni.yml" ]

#ENTRYPOINT ["tini", "-s", "--", "docker-entrypoint.sh"]
CMD ["/usr/bin/docker-entrypoint.sh"]