################################################################################
# https://github.com/linuxserver/docker-code-server/pkgs/container/code-server
################################################################################
FROM epicmorg/vscode-server:latest

LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   ARGuments
##################################################################
ENV BuildDocker true

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public  | apt-key add - && \
    echo 'deb https://packages.adoptium.net/artifactory/deb focal main' > /etc/apt/sources.list.d/temurin-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated temurin-11-jdk && \
    mkdir /usr/lib/jvm/temurin-11-jdk-amd64/jre && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/bin/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/bin && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/lib/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/lib && \
    java -version

##################################################################
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.6
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=/opt/maven
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/MAVEN.zip

ENV GRADLE_VERSION=8.6
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=/opt/gradle
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle.zip

ENV KTC_VERSION=1.9.22
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlinc.zip
ENV KTC_ROOT=/opt/kotlin
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=${KTC_PATH}/bin

RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${GRADLE_PATH}
ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}

##################################################################
#                   Maven
##################################################################
ENV MAVEN_HOME=${MAVEN_ROOT}
ENV M2_HOME=${MAVEN_ROOT}

RUN curl --insecure --progress-bar -L -o ${MAVEN_TEMP} --retry 10 --retry-delay 0 ${MAVEN_LINK}
RUN 7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT}
RUN chmod +x -R ${MAVEN_BIN}
RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
RUN curl --insecure --progress-bar -L -o ${GRADLE_TEMP} --retry 10 --retry-delay 0 ${GRADLE_LINK}
RUN 7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT}
RUN chmod +x -R ${GRADLE_BIN}
RUN gradle -v

##################################################################
#                   KOTLIN
##################################################################
RUN curl --insecure --progress-bar -L -o ${KTC_TEMP} --retry 10 --retry-delay 0 ${KTC_LINK}
RUN 7zz x $KTC_TEMP -o${KTC_ROOT}
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

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
#                   cleaninig up
##################################################################
RUN apt purge policykit-1 -y && \
    apt clean -y && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/mc.patch && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/7z && \
    rm -rfv /tmp/deb/* && \
    rm -rfv /tmp/composer-setup.php && \
    rm -rfv /tmp/amxx_base_latest.tar.gz && \
    rm -rfv /tmp/atlassian-plugin-sdk.deb && \
    rm -rfv /tmp/addons
