FROM docker.io/epicmorg/debian:bookworm-develop-jdk17
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

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

RUN updatedb
