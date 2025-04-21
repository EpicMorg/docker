FROM quay.io/epicmorg/teamcity-agent:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG K_JDK_MAJOR_VERSION=17
ARG K_JDK_FULL_VERSION=jdk-17.0.15
ARG K_JDK_VERSION=17.0.15
ARG K_JDK_BUILD_VERSION=6
ARG K_JDK_DIR=${EMG_LOCAL_BASE_DIR}/java/${K_JDK_MAJOR_VERSION}
ARG K_JDK_URL=https://github.com/adoptium/temurin${K_JDK_MAJOR_VERSION}-binaries/releases/download/${K_JDK_FULL_VERSION}+${K_JDK_BUILD_VERSION}/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz
ARG K_JDK_TEMP=/tmp/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}_${K_JDK_BUILD_VERSION}.tar.gz

ENV JAVA_HOME=${K_JDK_DIR}
ENV JRE_HOME=${JAVA_HOME}
ENV JDK_HOME=${JAVA_HOME}
ENV PATH=$PATH:${JAVA_HOME}/bin

##################################################################
#                   installing java17
##################################################################
ADD ${K_JDK_URL} /tmp
RUN mkdir -p ${K_JDK_DIR} && \
    tar -xvzf ${K_JDK_TEMP} --strip-components=1 --directory ${K_JDK_DIR} && \
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
#                   Android SDK
##################################################################
ENV ANDROID_HOME=${EMG_LOCAL_BASE_DIR}/android/sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}

RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
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
      "platforms;android-21" \
      "platforms;android-34" \
      "platforms;android-35" \
#
      "build-tools;21.1.2" \
      "build-tools;34.0.0" \
      "build-tools;35.0.0" \
#
      "extras;android;m2repository" \
#
      "ndk;25.1.8937393" \
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

RUN updatedb
