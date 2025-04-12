FROM hub.epicm.org/epicmorg/gitlab-runner:minimal
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG K_JDK_MAJOR_VERSION=8
ARG K_JDK_FULL_VERSION=jdk8u432
ARG K_JDK_VERSION=8u432
ARG K_JDK_BUILD_VERSION=b06
ARG K_JDK_DIR=${EMG_LOCAL_BASE_DIR}/java/${K_JDK_MAJOR_VERSION}
ARG K_JDK_URL=https://github.com/adoptium/temurin${K_JDK_MAJOR_VERSION}-binaries/releases/download/${K_JDK_FULL_VERSION}-${K_JDK_BUILD_VERSION}/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}${K_JDK_BUILD_VERSION}.tar.gz
ARG K_JDK_TEMP=/tmp/OpenJDK${K_JDK_MAJOR_VERSION}U-jdk_x64_linux_hotspot_${K_JDK_VERSION}${K_JDK_BUILD_VERSION}.tar.gz

ENV JAVA_HOME=${K_JDK_DIR}
ENV JRE_HOME=${JAVA_HOME}
ENV JDK_HOME=${JAVA_HOME}
ENV PATH=$PATH:${JAVA_HOME}/bin

##################################################################
#                   installing java8
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
#                   Additional settings
##################################################################
ENV MAVEN_VERSION=3.9.9
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=${EMG_LOCAL_BASE_DIR}/maven/${MAVEN_VERSION}
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=${MAVEN_PATH}/bin
ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

ENV GRADLE_VERSION=8.13
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=${EMG_LOCAL_BASE_DIR}/gradle/${GRADLE_VERSION}
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=${GRADLE_PATH}/bin
ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

ENV KTC_VERSION=2.1.10
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
RUN tar -xvzf ${KNPL_TEMP} --directory ${KTC_ROOT}
RUN chmod +x -R ${KNPL_BIN}

##################################################################
#                    Atlassian SDK Setup
##################################################################

ENV ATLASSIAN_SDK_DIR=${EMG_LOCAL_BASE_DIR}/atlassian
ENV ATLASSIAN_SDK_BIN_DIR=${ATLASSIAN_SDK_DIR}/bin
ENV ATLASSIAN_SDK_TEMP=/tmp/atlassian-plugin-sdk.tgz

###############################
# https://community.atlassian.com/t5/Continuous-Delivery-questions/The-repository-https-packages-atlassian-com-atlassian-sdk-deb/qaq-p/1334014
#
# https://community.developer.atlassian.com/t/the-repository-https-packages-atlassian-com-atlassian-sdk-deb-stable-release-is-not-signed/36901
###############################
#COPY etc/apt/keyrings/atlassian.asc /etc/apt/keyrings/
#COPY etc/apt/sources.list.d/atlassian-sdk.list /etc/apt/sources.list.d/
#RUN apt-get update  --allow-insecure-repositories && \
#    apt-get install -y --no-install-recommends  --allow-unauthenticated  \
#      atlassian-plugin-sdk
#Install packages
#RUN curl -SL https://packages.atlassian.com/atlassian-sdk-deb/debian/pool/contrib/a/atlassian-plugin-sdk/atlassian-plugin-sdk_8.0.16_all.deb -o /tmp/atlassian-plugin-sdk.deb && \
#    dpkg -i /tmp/atlassian-plugin-sdk.deb

RUN mkdir -p ${ATLASSIAN_SDK_BIN_DIR} && \
    wget -O ${ATLASSIAN_SDK_TEMP} "https://marketplace.atlassian.com/download/plugins/atlassian-plugin-sdk-tgz" && \
    tar -xvzf /tmp/atlassian-plugin-sdk.tgz --strip-components=1 --directory ${ATLASSIAN_SDK_DIR}

ENV PATH=$PATH:${ATLASSIAN_SDK_BIN_DIR}

##################################################################
#                   Version after install
##################################################################
RUN echo "=============================================" && \
    atlas-version && \
    echo "============================================="

##################################################################
#                   cleaninig up
##################################################################
RUN apt-get clean -y && \
    apt-get clean all -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
