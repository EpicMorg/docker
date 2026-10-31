FROM ghcr.io/epicmorg/debian:trixie
ARG DEBIAN_FRONTEND=noninteractive

LABEL org.opencontainers.image.title="EpicMorg Java"
LABEL org.opencontainers.image.description="JDK by EpicMorg"

ARG K_JDK_MAJOR_VERSION=24
ARG K_JDK_FULL_VERSION=jdk-24.0.2
ARG K_JDK_VERSION=24.0.2
ARG K_JDK_BUILD_VERSION=12
# sha256 of the archive (api.adoptium.net)
ARG K_JDK_SHA256=aea1cc55e51cf651c85f2f00ad021603fe269c4bb6493fa97a321ad770c9b096
ARG K_JDK_DIR=${EMG_LOCAL_BASE_DIR}/java/${K_JDK_MAJOR_VERSION}
ARG K_JDK_URL=https://github.com/adoptium/temurin${K_JDK_MAJOR_VERSION}-binaries/releases/download/${K_JDK_FULL_VERSION}+${K_JDK_BUILD_VERSION}/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz
ARG K_JDK_TEMP=/tmp/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz

ENV JAVA_HOME=${K_JDK_DIR}
ENV JRE_HOME=${JAVA_HOME}
ENV JDK_HOME=${JAVA_HOME}
ENV PATH=$PATH:${JAVA_HOME}/bin

##################################################################
#                   installing java24
##################################################################
RUN set -eux; \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${K_JDK_URL}" && \
    echo "${K_JDK_SHA256}  ${K_JDK_TEMP}" | sha256sum -c - && \
    mkdir -p ${K_JDK_DIR} && \
    tar -xzf ${K_JDK_TEMP} --strip-components=1 --directory ${K_JDK_DIR} && \
    ln -sfv ${JAVA_HOME} /usr/jre && \
    ln -sfv ${JAVA_HOME} /usr/jdk && \
    java -version && \
# cleanup
    apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/* 

##################################################################
#                   Update JavaCA
##################################################################
RUN update-ca-certificates --fresh && \
    for cert in /usr/local/share/ca-certificates/*.crt; do \
        alias=$(basename "$cert" .crt); \
        keytool -importcert \
            -keystore "$JAVA_HOME/lib/security/cacerts" \
            -storepass changeit \
            -file "$cert" \
            -alias "$alias" \
            -noprompt; \
    done

##################################################################
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.16
ENV MAVEN_LINK=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
# *_SHA256: published checksums (Apache .sha512 -> sha256 of the verified file, Gradle / Kotlin .sha256)
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip
ARG MAVEN_SHA256=5af3b743dd8b876b5c45da33b676251e5f1687712644abb4ee519ca56e1d89ce

ENV GRADLE_VERSION=9.5.1
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip
ARG GRADLE_SHA256=c72fb9991f6025cbe337d52ba77e531b3faf62bdd3e348fe1ccee9f51c71adb0

ENV KTC_VERSION=2.4.21
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_SHA256=7cc140e76daf416a0424a5557f99afd7ca89ebd463ea1101261e3e01c33e75cd
ENV KTC_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KTC_VERSION}
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

ENV KNPL_VERSION=${KTC_VERSION}
ENV KNPL_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KNPL_VERSION}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ARG KNPL_TEMP=/tmp/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ARG KNPL_SHA256=4935d8c8da90a2d2a8ff51da7d2c264c0d6026e1d35a8f169e218d9209965678
ENV KNPL_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KNPL_VERSION}
ENV KNPL_PATH=${KNPL_ROOT}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}
ENV KNPL_BIN=${KNPL_PATH}/bin

RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${KNPL_PATH} ${GRADLE_PATH}
ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}:${KNPL_BIN}

##################################################################
#                   Maven
##################################################################
ENV MAVEN_HOME=${MAVEN_ROOT}
ENV M2_HOME=${MAVEN_ROOT}

RUN set -eux; \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${MAVEN_LINK}" && \
    echo "${MAVEN_SHA256}  ${MAVEN_TEMP}" | sha256sum -c - && \
    7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT} && \
    rm -fv ${MAVEN_TEMP}
RUN chmod +x -R ${MAVEN_BIN}
RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
RUN set -eux; \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${GRADLE_LINK}" && \
    echo "${GRADLE_SHA256}  ${GRADLE_TEMP}" | sha256sum -c - && \
    7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT} && \
    rm -fv ${GRADLE_TEMP}
RUN chmod +x -R ${GRADLE_BIN}
RUN gradle -v

##################################################################
#                   kotlin-compiler
##################################################################
RUN set -eux; \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${KTC_LINK}" && \
    echo "${KTC_SHA256}  ${KTC_TEMP}" | sha256sum -c - && \
    7zz x ${KTC_TEMP} -o${KTC_ROOT} && \
    rm -fv ${KTC_TEMP}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

##################################################################
#                   kotlin-native-prebuilt-linux
##################################################################
RUN set -eux; \
    aria2c \
        --conf-path="/usr/local/share/epicmorg/aria2/config/aria2.conf" \
        --user-agent="$(shuf -n 1 /usr/local/share/epicmorg/user-agents/user-agents.txt)" \
        -d /tmp \
        "${KNPL_LINK}" && \
    echo "${KNPL_SHA256}  ${KNPL_TEMP}" | sha256sum -c - && \
    tar -xzf ${KNPL_TEMP} --directory ${KTC_ROOT} && \
    rm -fv ${KNPL_TEMP}
RUN chmod +x -R ${KNPL_BIN}

