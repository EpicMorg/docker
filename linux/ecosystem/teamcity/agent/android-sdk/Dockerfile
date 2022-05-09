FROM epicmorg/teamcity-agent:latest
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

##################################################################
#                   Android SDK
##################################################################
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

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
#                   SDKMAN
##################################################################
#RUN curl -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -s "http://get.sdkman.io" | bash
COPY ./sdkman.sh /tmp/sdkman.sh
RUN export SDKMAN_DIR="/config/.sdkman" && chmod +x /tmp/sdkman.sh
RUN /tmp/sdkman.sh

##################################################################
#                   Gradle
##################################################################
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh; sdk install gradle;"

##################################################################
#                   Kotlin
##################################################################
RUN /bin/bash -c "source /root/.sdkman/bin/sdkman-init.sh; sdk install kotlin;"

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/archives/*.deb && \
    rm -rfv /tmp/*