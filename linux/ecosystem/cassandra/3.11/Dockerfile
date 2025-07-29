FROM epicmorg/debian:bookworm-python-2.7  as builder

RUN echo "=============================================" && \
    python${PYTHON_VERSION} --version && \
    python2 --version && \
    python --version && \
    pip2 --version && \
    pip --version && \
#    echo "=============================================" && \
#    python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)" && \
    echo "============================================="

##################################################################
##################################################################
##################################################################
#                  Final Layer
##################################################################
##################################################################
##################################################################

FROM epicmorg/debian:bookworm-jdk8

##################################################################
#                  Python 2.7
##################################################################
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV PYTHON_VERSION=2.7
ENV PYTHON_FULL_VERSION=${PYTHON_VERSION}.18
ENV PYTHON_DIR=${EMG_LOCAL_BASE_DIR}/python/${PYTHON_VERSION}
ARG PYTHON_BIN_DIR=${PYTHON_DIR}/bin
ARG PYTHON_SRC_DIR=${PYTHON_DIR}/src

COPY etc/apt/preferences.d /etc/apt/preferences.d
COPY --from=builder ${PYTHON_DIR} ${PYTHON_DIR}

ENV PATH="${PYTHON_BIN_DIR}:${PATH}"

RUN mv ${PYTHON_SRC_DIR} /usr/local/src/${PYTHON_FULL_VERSION} && \
    ln -sfv /usr/local/src/${PYTHON_FULL_VERSION} ${PYTHON_SRC_DIR} && \
    rm -rfv /usr/bin/pip3 && \
    rm -rfv /usr/bin/pip2 && \
    rm -rfv /usr/bin/pip && \
    rm -rfv /usr/bin/python && \
    rm -rfv /usr/bin/python2 && \
    rm -rfv /usr/bin/python3 && \
    update-alternatives --install /usr/bin/pip2 pip2 ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/pip pip ${PYTHON_DIR}/bin/pip${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python python ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    update-alternatives --install /usr/bin/python2 python2 ${PYTHON_DIR}/bin/python${PYTHON_VERSION} 1 && \
    ldconfig

RUN echo "=============================================" && \
    python${PYTHON_VERSION} --version && \
    python2 --version && \
    python --version && \
    pip2 --version && \
    pip --version && \
#    echo "=============================================" && \
#    python${PYTHON_VERSION} -c "import ssl; print(ssl.OPENSSL_VERSION)" && \
    echo "============================================="

##################################################################
#                  Cassandra
##################################################################

# explicitly set user/group IDs
RUN set -eux; \
	groupadd -r cassandra --gid=1337; \
	useradd -r -g cassandra --uid=1337 cassandra

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
# solves warning: "jemalloc shared library could not be preloaded to speed up memory allocations"
		libjemalloc2 \
# "free" is used by cassandra-env.sh
		procps \
# "cqlsh" needs a python interpreter
#		python2 \
# "ip" is not required by Cassandra itself, but is commonly used in scripting Cassandra's configuration (since it is so fixated on explicit IP addresses)
		iproute2 \
# Cassandra will automatically use numactl if available
#   https://github.com/apache/cassandra/blob/18bcda2d4c2eba7370a0b21f33eed37cb730bbb3/bin/cassandra#L90-L100
#   https://github.com/apache/cassandra/commit/604c0e87dc67fa65f6904ef9a98a029c9f2f865a
		numactl \
	; \
	rm -rf /var/lib/apt/lists/*; \
# https://issues.apache.org/jira/browse/CASSANDRA-15767 ("bin/cassandra" only looks for "libjemalloc.so" or "libjemalloc.so.1" which doesn't match our "libjemalloc.so.2")
	libjemalloc="$(readlink -e /usr/lib/*/libjemalloc.so.2)"; \
	ln -sT "$libjemalloc" /usr/local/lib/libjemalloc.so; \
	ldconfig

# grab gosu for easy step-down from root
# https://github.com/tianon/gosu/releases
RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates gnupg wget; \
	rm -rf /var/lib/apt/lists/*; \
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	gosu --version; \
	gosu nobody true

ENV CASSANDRA_HOME /opt/cassandra
ENV CASSANDRA_CONF /etc/cassandra
ENV CASSANDRA_DATA /var/lib/cassandra
ENV CASSANDRA_VERSION 3.11.19
ENV CASSANDRA_SHA512 42d7732c2b81c65a960101d1146603d430de341adcdf8d0ffc649753a340cf64dad696050f2ec01faff5f15e726f4f2a459f0b3ac281569b957f7726f51d43e0

ARG CASSANDRA_LUCENE_PLUGIN_DEST=${CASSANDRA_HOME}/lib/
#ENV CASSANDRA_LUCENE_PLUGIN_VER=3.11.10.0
#ARG CASSANDRA_LUCENE_PLUGIN_URL=https://github.com/EpicMorg/cassandra-lucene-index/releases/download/${CASSANDRA_LUCENE_PLUGIN_VER}/cassandra-lucene-index-plugin-${CASSANDRA_LUCENE_PLUGIN_VER}.jar

ENV PATH ${CASSANDRA_HOME}/bin:$PATH

# https://cwiki.apache.org/confluence/display/CASSANDRA2/DebianPackaging#DebianPackaging-AddingRepositoryKeys
# $ docker run --rm buildpack-deps:bullseye-curl bash -c 'wget -qO- https://downloads.apache.org/cassandra/KEYS | gpg --batch --import &> /dev/null && gpg --batch --list-keys --with-fingerprint --with-colons' | awk -F: '$1 == "pub" && $2 == "-" { pub = 1 } pub && $1 == "fpr" { fpr = $10 } $1 == "sub" { pub = 0 } pub && fpr && $1 == "uid" && $2 == "-" { print "#", $10; print "\t" fpr " \\"; pub = 0 }'
ENV GPG_KEYS \
# Eric Evans <eevans@sym-link.com>
	CEC86BB4A0BA9D0F90397CAEF8358FA2F2833C93 \
# Eric Evans <eevans@sym-link.com>
	C4965EE9E3015D192CCCF2B6F758CE318D77295D \
# Sylvain Lebresne (pcmanus) <sylvain@datastax.com>
	5AED1BF378E9A19DADE1BCB34BD736A82B5C1B00 \
# T Jake Luciani <jake@apache.org>
	514A2AD631A57A16DD0047EC749D6EEC0353B12C \
# Michael Shuler <michael@pbandjelly.org>
	A26E528B271F19B9E5D8E19EA278B781FE4B2BDA \
# Michael Semb Wever <mick@thelastpickle.com>
	A4C465FEA0C552561A392A61E91335D77E3E87CB \
# Alex Petrov <oleksandr.petrov@gmail.com>
	9E66CEC6106D578D0B1EB9BFF1000962B7F6840C \
# Jordan West <jwest@apache.org>
	C4009872C59B49561310D966D0062876AF30F054 \
# Brandon Williams <brandonwilliams@apache.org>
	B7842CDAF36E6A3214FAE35D5E85B9AE0B84C041 \
# Ekaterina Buryanova Dimitrova (CODE SIGNING KEY) <e.dimitrova@gmail.com>
	3E9C876907A560ACA00964F363E9BAD215BBF5F0 \
# Sam Tunnicliffe (CODE SIGNING KEY) <samt@apache.org>
	F8B7FD00E05C932991A2CD6150EE103D162C5A55 \
# Stefan Miklosovic <smiklosovic@apache.org>
	7464AAD9068241C50BA6A26232F35CB2F546D93E \
# Berenguer Blasi (Code Signing Key) <bereng@apache.org>
	CEC5C50B9C629EF0F5AB2706650B72EB14CCD622

RUN set -eux; \
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates gnupg wget; \
	rm -rf /var/lib/apt/lists/*; \
	\
	ddist() { \
		local f="$1"; shift; \
		local distFile="$1"; shift; \
		local success=; \
		local distUrl=; \
		for distUrl in \
# https://github.com/docker-library/tomcat/pull/308
			https://dlcdn.apache.org/ \
# if the version is outdated, we have to pull from the archive
			https://archive.apache.org/dist/ \
		; do \
			if wget --progress=dot:giga -O "$f" "$distUrl$distFile" && [ -s "$f" ]; then \
				success=1; \
				break; \
			fi; \
		done; \
		[ -n "$success" ]; \
	}; \
	\
	ddist 'cassandra-bin.tgz' "cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz"; \
	echo "$CASSANDRA_SHA512 *cassandra-bin.tgz" | sha512sum --check --strict -; \
	\
	ddist 'cassandra-bin.tgz.asc' "cassandra/$CASSANDRA_VERSION/apache-cassandra-$CASSANDRA_VERSION-bin.tar.gz.asc"; \
	export GNUPGHOME="$(mktemp -d)"; \
	for key in $GPG_KEYS; do \
		gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
	done; \
	gpg --batch --verify cassandra-bin.tgz.asc cassandra-bin.tgz; \
	rm -rf "$GNUPGHOME"; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	\
	mkdir -p "${CASSANDRA_HOME}"; \
	tar --extract --file cassandra-bin.tgz --directory "${CASSANDRA_HOME}" --strip-components 1; \
	rm cassandra-bin.tgz*; \
	\
	[ ! -e "${CASSANDRA_CONF}" ]; \
	mv "${CASSANDRA_HOME}/conf" "${CASSANDRA_CONF}"; \
	ln -sT "${CASSANDRA_CONF}" "${CASSANDRA_HOME}/conf"; \
	\
	dpkgArch="$(dpkg --print-architecture)"; \
	case "$dpkgArch" in \
		ppc64el) \
# https://issues.apache.org/jira/browse/CASSANDRA-13345
# "The stack size specified is too small, Specify at least 328k"
			grep -- '^-Xss256k$' "${CASSANDRA_CONF}/jvm.options"; \
			sed -ri 's/^-Xss256k$/-Xss512k/' "${CASSANDRA_CONF}/jvm.options"; \
			grep -- '^-Xss512k$' "${CASSANDRA_CONF}/jvm.options"; \
			;; \
	esac; \
	\
	mkdir -p "${CASSANDRA_CONF}" ${CASSANDRA_DATA} /var/log/cassandra; \
	chown -R cassandra:cassandra "${CASSANDRA_CONF}" ${CASSANDRA_DATA} /var/log/cassandra; \
	chmod 1777 "${CASSANDRA_CONF}" ${CASSANDRA_DATA} /var/log/cassandra; \
	chmod -R a+rwX "${CASSANDRA_CONF}"; \
	ln -sT ${CASSANDRA_DATA} "${CASSANDRA_HOME}/data"; \
	ln -sT /var/log/cassandra "${CASSANDRA_HOME}/logs"; \
	mkdir -p /usr/share/cassandra /usr/local/share/cassandra ; \
	ln -sT "${CASSANDRA_HOME}/lib" /usr/share/cassandra/lib ; \
	ln -sT "${CASSANDRA_HOME}/lib" /usr/local/share/cassandra/lib ; \
	ln -sT "${CASSANDRA_HOME}" ${EMG_LOCAL_BASE_DIR}/cassandra ; \
	\
# smoke test
	cassandra -v

##################################################################
#                   Install Cassandra Plugin
##################################################################
COPY opt/cassandra/lib/cassandra-lucene-index-plugin-3.11.4.jar ${CASSANDRA_LUCENE_PLUGIN_DEST}/

VOLUME ${CASSANDRA_DATA}

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR ${CASSANDRA_HOME}

ENTRYPOINT ["docker-entrypoint.sh"]

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160
CMD ["cassandra", "-f"]

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

##################################################################
#                  update file db
##################################################################
RUN updatedb
