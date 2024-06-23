FROM epicmorg/debian:bullseye
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ARG K_JDK_VERSION=6.22.0.3
ARG K_JDK_BUILD_VERSION=6.0.119
ARG K_JDK_URL=http://cdn.azul.com/zulu/bin/zulu${K_JDK_VERSION}-jdk${K_JDK_BUILD_VERSION}-linux_x64.tar.gz
ARG K_JDK_TEMP=/tmp/zulu${K_JDK_VERSION}-jdk${K_JDK_BUILD_VERSION}-linux_x64.tar.gz

ENV JAVA_HOME=/usr/local/zulu${K_JDK_VERSION}-jdk${K_JDK_BUILD_VERSION}-linux_x64
ENV PATH=$PATH:${JAVA_HOME}/bin

##################################################################
#                   installing java6
##################################################################
ADD ${K_JDK_URL} /tmp
RUN tar -xvzf /tmp/zulu${K_JDK_VERSION}-jdk${K_JDK_BUILD_VERSION}-linux_x64.tar.gz  --directory /usr/local && \
    java -version

##################################################################
#                   Additional settings
##################################################################
#ENV MAVEN_VERSION=3.9.8
#ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
#ENV MAVEN_ROOT=/usr/local/maven
#ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
#ENV MAVEN_BIN=${MAVEN_PATH}/bin
#ARG MAVEN_TEMP=/tmp/apache-maven-${MAVEN_VERSION}-bin.zip

#ENV GRADLE_VERSION=7.6.4
#ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
#ENV GRADLE_ROOT=/usr/local/gradle
#ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
#ENV GRADLE_BIN=${GRADLE_PATH}/bin
#ARG GRADLE_TEMP=/tmp/gradle-${GRADLE_VERSION}-all.zip

#ENV KTC_VERSION=2.0.0
#ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
#ARG KTC_TEMP=/tmp/kotlin-compiler-${KTC_VERSION}.zip
#ENV KTC_ROOT=/usr/local/kotlin
#ENV KTC_PATH=${KTC_ROOT}/kotlinc
#ENV KTC_BIN=${KTC_PATH}/bin

#RUN mkdir -p ${MAVEN_PATH} ${KTC_PATH} ${KNPL_PATH} ${GRADLE_PATH}
#ENV PATH=${PATH}:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}:${KNPL_BIN}

##################################################################
#                   Maven
##################################################################
#ENV MAVEN_HOME=${MAVEN_ROOT}
#ENV M2_HOME=${MAVEN_ROOT}

#ADD ${MAVEN_LINK} /tmp
#RUN 7zz x ${MAVEN_TEMP} -o${MAVEN_ROOT}
#RUN chmod +x -R ${MAVEN_BIN}
#RUN mvn -v

##################################################################
#                   GRADLE
##################################################################
#ADD ${GRADLE_LINK} /tmp
#RUN 7zz x ${GRADLE_TEMP} -o${GRADLE_ROOT}
#RUN chmod +x -R ${GRADLE_BIN}
#RUN gradle -v

##################################################################
#                   kotlin-compiler
##################################################################
#ADD ${KTC_LINK} /tmp
#RUN 7zz x ${KTC_TEMP} -o${KTC_ROOT}
#RUN chmod +x -R ${KTC_BIN}
#RUN kotlin -version

##################################################################
#                   kotlin-native-prebuilt-linux
##################################################################
#ADD ${KNPL_LINK} /tmp
#RUN tar -xvzf ${KNPL_TEMP} --directory ${KTC_ROOT}
#RUN chmod +x -R ${KNPL_BIN}

##################################################################
#                  cleanup
##################################################################
RUN echo "clean up" && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
