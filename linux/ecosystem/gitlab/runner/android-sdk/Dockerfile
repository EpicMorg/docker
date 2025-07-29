FROM epicmorg/gitlab-runner:minimal
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
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.11
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.14
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=2.2.0
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
ENV KTC_ROOT=${EMG_LOCAL_BASE_DIR}/kotlin/${KTC_VERSION}
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

ENV KNPL_VERSION=${KTC_VERSION}
ENV KNPL_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KNPL_VERSION}/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
ARG KNPL_TEMP=/tmp/kotlin-native-prebuilt-linux-x86_64-${KNPL_VERSION}.tar.gz
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

ADD ${MAVEN_LINK} /tmp
RUN 7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT}
RUN chmod +x -R ${MAVEN_BIN}
RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
ADD ${GRADLE_LINK} /tmp
RUN 7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT}
RUN chmod +x -R ${GRADLE_BIN}
RUN gradle -v

##################################################################
#                   kotlin-compiler
##################################################################
ADD ${KTC_LINK} /tmp
RUN 7zz x ${KTC_TEMP} -o${KTC_ROOT}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

##################################################################
#                   kotlin-native-prebuilt-linux
##################################################################
ADD ${KNPL_LINK} /tmp
RUN tar -xzf ${KNPL_TEMP} --directory ${KTC_ROOT}
RUN chmod +x -R ${KNPL_BIN}


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

RUN updatedb
