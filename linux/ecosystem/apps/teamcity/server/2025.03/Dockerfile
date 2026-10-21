##################################################################
#      TeamCity server 2025.03: JetBrains' distribution, our base
##################################################################
# All teamcity-server leaves share this file (bin/python/teamcity-server-sync.py);
# they differ only in the release and the JDK major. The distribution and the
# start-up scripts come from JetBrains' image of the same tag; base, JDK and
# tooling are ours (epicmorg/jdk: trixie + JDK 21 + Maven, Gradle, Kotlin, p4,
# git / git-lfs / gh, 7-Zip, CAs in the system store and in cacerts).
FROM docker.io/jetbrains/teamcity-server:2025.03 AS upstream

FROM ghcr.io/epicmorg/jdk:21
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="EpicMorg TeamCity Server"
LABEL org.opencontainers.image.description="JetBrains TeamCity server on Debian trixie + JDK 21 with p4, git/git-lfs/gh, Maven, Gradle, Kotlin, extra CAs, by EpicMorg"
LABEL org.opencontainers.image.source="https://github.com/EpicMorg/docker"
LABEL org.opencontainers.image.licenses="MIT"

ENV TEAMCITY_RELEASE=2025.03
ENV TEAMCITY_JDK=21
# = jetbrains/teamcity-server
ENV TEAMCITY_DATA_PATH=/data/teamcity_server/datadir
ENV TEAMCITY_DIST=/opt/teamcity
ENV TEAMCITY_LOGS=/opt/teamcity/logs
ENV TEAMCITY_ENV=container
ENV CATALINA_TMPDIR=/opt/teamcity/temp
ENV TEAMCITY_SERVER_MEM_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=640m"
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

##################################################################
#                   Runtime packages
##################################################################
# What JetBrains' image installs on top of Ubuntu and our base does not have:
# en_US.UTF-8 locale (LC_ALL above), netcat (their scripts), fontconfig (charts).
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends fontconfig locales netcat-openbsd; \
    sed -i -E 's/^# *(en_US\.UTF-8 UTF-8)/\1/' /etc/locale.gen; \
    grep -q '^en_US.UTF-8 UTF-8' /etc/locale.gen || echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen; \
    locale-gen; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/*

##################################################################
#                   TeamCity (from JetBrains' image)
##################################################################
# tcuser 1000:1000 as upstream owns the distribution; the image keeps USER root
# like our earlier ones (mounted volumes need no ownership change) - run with
# --user 1000:1000 for upstream behaviour. /opt/java/openjdk = upstream JAVA_HOME,
# linked for scripts / configs that point there.
RUN set -eux; \
    groupadd -g 1000 tcuser; \
    useradd -r -M -u 1000 -g tcuser -d /opt/teamcity -s /bin/bash tcuser; \
    mkdir -p /opt/java /data/teamcity_server/datadir; \
    ln -sfn "${JAVA_HOME}" /opt/java/openjdk
COPY --from=upstream --chown=1000:1000 /opt/teamcity /opt/teamcity
COPY --from=upstream /run-server.sh /run-services.sh /welcome.sh /
COPY --from=upstream /services/ /services/
RUN set -eux; \
    chown 1000:1000 /data/teamcity_server/datadir; \
    chmod +x /run-server.sh /run-services.sh /welcome.sh /services/*.sh

##################################################################
#                       Assertions (fatal)
##################################################################
RUN set -eu; \
    java -version 2>&1 | head -1 | grep -qE "version \"${TEAMCITY_JDK}[.\"]" \
      || { echo "FATAL: java is not ${TEAMCITY_JDK}" >&2; java -version >&2; exit 1; }; \
    /opt/java/openjdk/bin/java -version >/dev/null 2>&1 || { echo "FATAL: /opt/java/openjdk" >&2; exit 1; }; \
    test -x /opt/teamcity/bin/teamcity-server.sh || { echo "FATAL: no TeamCity distribution" >&2; exit 1; }; \
    test -x /run-services.sh && test -x /run-server.sh || { echo "FATAL: no start-up scripts" >&2; exit 1; }; \
    [ "$(stat -c %u /opt/teamcity/bin)" = 1000 ] || { echo "FATAL: /opt/teamcity not owned by tcuser" >&2; exit 1; }; \
    locale -a | grep -qix 'en_US.utf8' || { echo "FATAL: en_US.UTF-8 locale missing" >&2; exit 1; }; \
    for t in p4 git git-lfs gh hg svn mvn gradle kotlinc 7zz nc; do \
      command -v "$t" >/dev/null || { echo "FATAL: $t missing" >&2; exit 1; }; \
    done; \
    keytool -list -cacerts -storepass changeit | grep -qi epicmorg || { echo "FATAL: EpicMorg CA not in cacerts" >&2; exit 1; }; \
    ls /opt/teamcity/BUILD_* 2>/dev/null || true; \
    java -version 2>&1 | head -1; p4 -V | tail -1; git --version

VOLUME ["/data/teamcity_server/datadir", "/opt/teamcity/logs", "/opt/teamcity/temp"]
EXPOSE 8111
CMD ["/run-services.sh"]
