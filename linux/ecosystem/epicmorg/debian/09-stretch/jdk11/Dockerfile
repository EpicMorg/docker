FROM epicmorg/debian:stretch
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   installing java11
##################################################################
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public  | apt-key add - && \
    echo 'deb https://packages.adoptium.net/artifactory/deb stretch main' > /etc/apt/sources.list.d/temurin-official.list && \
    apt-get update && \
    apt-get autoremove -y && \
    apt-get install -y --allow-unauthenticated temurin-11-jdk && \
    mkdir /usr/lib/jvm/temurin-11-jdk-amd64/jre && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/bin/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/bin && \
    ln -s /usr/lib/jvm/temurin-11-jdk-amd64/lib/ /usr/lib/jvm/temurin-11-jdk-amd64/jre/lib && \
    java -version

##################################################################
#                   Maven
##################################################################
ENV MAVEN_VERSION=3.9.5
ENV MAVEN_LINK=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip
ENV MAVEN_ROOT=/opt/maven
ENV MAVEN_PATH=${MAVEN_ROOT}/apache-maven-${MAVEN_VERSION}
ENV MAVEN_BIN=$MAVEN_PATH/bin
ARG MAVEN_TEMP=/tmp/MAVEN.zip

ENV MAVEN_HOME=${MAVEN_ROOT}
ENV M2_HOME=${MAVEN_ROOT}

RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${MAVEN_LINK} -O ${MAVEN_TEMP}
RUN 7zz x $MAVEN_TEMP -o$MAVEN_ROOT
RUN chmod +x -R $MAVEN_BIN
RUN mvn -version

##################################################################
#                   GRADLE
##################################################################
ENV GRADLE_VERSION=8.4
ENV GRADLE_LINK=https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip
ENV GRADLE_ROOT=/opt/gradle
ENV GRADLE_PATH=${GRADLE_ROOT}/gradle-${GRADLE_VERSION}
ENV GRADLE_BIN=$GRADLE_PATH/bin
ARG GRADLE_TEMP=/tmp/gradle.zip

RUN mkdir -p $GRADLE_PATH
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue $GRADLE_LINK -O $GRADLE_TEMP
RUN 7zz x $GRADLE_TEMP -o$GRADLE_ROOT
RUN chmod +x -R $GRADLE_BIN
RUN gradle -v

##################################################################
#                   KOTLIN
##################################################################
ENV KTC_VERSION=1.9.20
ENV KTC_LINK=https://github.com/JetBrains/kotlin/releases/download/v${KTC_VERSION}/kotlin-compiler-${KTC_VERSION}.zip
ARG KTC_TEMP=/tmp/kotlinc.zip
ENV KTC_ROOT=/opt/kotlin
ENV KTC_PATH=${KTC_ROOT}/kotlinc
ENV KTC_BIN=$KTC_PATH/bin

RUN mkdir -p ${KTC_PATH}
RUN wget --no-check-certificate -nv --random-wait --retry-connrefused --continue ${KTC_LINK} -O ${KTC_TEMP}
RUN 7zz x $KTC_TEMP -o$KTC_ROOT
RUN chmod +x -R ${KTC_BIN}
RUN kotlin -version

ENV PATH=$PATH:${MAVEN_BIN}:${GRADLE_BIN}:${KTC_BIN}

##################################################################
#                  cleanup
##################################################################
RUN apt-get purge policykit-1 -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /tmp/* && \
    rm -rfv /var/cache/apt/archives/*.deb
