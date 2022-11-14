FROM epicmorg/teamcity-agent:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

ENV GRADLE_VERSION=7.4.2
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=/opt/gradle
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=$GRADLE_PATH/bin
ARG GRADLE_TEMP=/tmp/gradle.zip

ENV KTC_VERSION=1.6.21
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlinc.tgz
ENV KTC_ROOT=/opt/kotlin
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=$KTC_PATH/bin

ENV PATH=PATH=$PATH:$GRADLE_BIN:${KTC_BIN}

##################################################################
#                   Android SDK
##################################################################
RUN apt update && \
    apt install -y --allow-unauthenticated \
      android-sdk \
      android-sdk-build-tools \
      android-sdk-platform-tools-common \
      android-sdk-platform-tools \
      adb fastboot f2fs-tools e2fsprogs libsqlite3-0 sqlite3

# Activate android sdk
RUN echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /usr/lib/android-sdk/licenses/android-sdk-license

##################################################################
#                   GRADLE
##################################################################
RUN mkdir -p $GRADLE_PATH
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue $GRADLE_LINK -O $GRADLE_TEMP
RUN 7zz x $GRADLE_TEMP -o$GRADLE_ROOT
RUN chmod +x -R $GRADLE_BIN
RUN gradle -v

##################################################################
#                   KOTLIN
##################################################################
RUN mkdir -p ${KTC_PATH}
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${KTC_LINK} -O ${KTC_TEMP}
RUN 7zz x $KTC_TEMP -o$KTC_ROOT
RUN chmod +x -R ${KTC_BIN}
RUN kotlinc -version

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*
