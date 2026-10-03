FROM docker.io/epicmorg/jdk:17 AS jdk

FROM docker.io/epicmorg/teamcity-agent:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#              Java 17 (prebuilt epicmorg/jdk image)
##################################################################
# Same pattern as teamcity-agent:minimal with jdk:21 (ADR-045): the JDK is
# taken as-is from the jdk image instead of a second Temurin download.
# Android tooling (AGP / sdkmanager) wants 17, so 17 is the default java here;
# maven / gradle / kotlin stay as provided by the minimal agent.
ENV JAVA_HOME=${EMG_LOCAL_BASE_DIR}/java/17
ENV JRE_HOME=${JAVA_HOME}
ENV JDK_HOME=${JAVA_HOME}
ENV PATH=${JAVA_HOME}/bin:${PATH}

COPY --from=jdk ${EMG_LOCAL_BASE_DIR}/java/17/ ${EMG_LOCAL_BASE_DIR}/java/17/

RUN set -eu; \
    ln -sfnv ${JAVA_HOME} /usr/jre; \
    ln -sfnv ${JAVA_HOME} /usr/jdk; \
    for b in ${JAVA_HOME}/bin/*; do ln -sfn "$b" /usr/local/bin/; done; \
    java -version; \
    java -version 2>&1 | grep -q 'version "17\.' || { echo "FATAL: java is not 17" >&2; exit 1; }; \
    [ "$(readlink -f "$(command -v java)")" = "${JAVA_HOME}/bin/java" ] || { echo "FATAL: java not from ${JAVA_HOME}" >&2; exit 1; }

##################################################################
#                   Android SDK
##################################################################
ENV ANDROID_HOME=${EMG_LOCAL_BASE_DIR}/android/sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      android-sdk \
      sdkmanager \
      android-sdk-build-tools \
      android-sdk-platform-tools-common \
      android-sdk-platform-tools \
      adb fastboot f2fs-tools e2fsprogs libsqlite3-0 sqlite3 && \
    mkdir -p ${ANDROID_HOME} && \
    sdkmanager --version && \
    gradle -v && \
    mvn -v

RUN sdkmanager --install --verbose \
      "cmake;3.22.1" \
#
      "cmdline-tools;latest" \
#
      "tools" \
#
      "platform-tools"  \
#
      "platforms;android-35" \
#
      "build-tools;35.0.0" \
#
      "extras;android;m2repository" \
#
      "ndk;25.2.9519653"

ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/tools/proguard/bin:${ANDROID_SDK_ROOT}/platform-tools:${PATH}"

# Activate android sdk
RUN yes | sdkmanager --licenses && \
    flutter doctor && \
    yes | sdkmanager --licenses && \
    flutter doctor -v

##################################################################
#                  Cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*

##################################################################
#                   final config
##################################################################
WORKDIR ${AGENT_DIST}
