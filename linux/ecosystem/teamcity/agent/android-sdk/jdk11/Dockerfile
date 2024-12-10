FROM epicmorg/teamcity-agent:latest-jdk11
LABEL maintainer="EpicMorg DevTeam, developer@epicm.org"
ARG DEBIAN_FRONTEND=noninteractive

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk

ENV PATH=$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:$ANDROID_SDK_ROOT/tools/bin

##################################################################
#                   Android SDK
##################################################################
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated --no-install-recommends --no-install-suggests \
      android-sdk \
      sdkmanager \
      android-sdk-build-tools \
      android-sdk-platform-tools-common \
      android-sdk-platform-tools \
      adb fastboot f2fs-tools e2fsprogs libsqlite3-0 sqlite3 && \
    apt remove -y gradle && \
    sdkmanager --version && \
    mvn -v

# Install ALL ANDROID SDK
RUN sdkmanager --install \
#      "build-tools;17.0.0" \
#      "build-tools;18.0.0" \
#      "build-tools;18.0.1" \
#      "build-tools;18.1.0" \
#      "build-tools;18.1.1" \
#      "build-tools;19.0.0" \
#      "build-tools;19.0.1" \
#      "build-tools;19.0.2" \
#      "build-tools;19.0.3" \
#      "build-tools;19.1.0" \
#      "build-tools;20.0.0" \
#      "build-tools;21.0.0" \
#      "build-tools;21.0.1" \
#      "build-tools;21.0.2" \
#      "build-tools;21.1.0" \
#      "build-tools;21.1.1" \
#      "build-tools;21.1.2" \
#      "build-tools;22.0.0" \
#      "build-tools;22.0.1" \
#      "build-tools;23.0.0" \
#      "build-tools;23.0.1" \
#      "build-tools;23.0.2" \
#      "build-tools;23.0.3" \
#      "build-tools;24.0.0" \
#      "build-tools;24.0.1" \
#      "build-tools;24.0.2" \
#      "build-tools;24.0.3" \
#      "build-tools;25.0.0" \
#      "build-tools;25.0.1" \
#      "build-tools;25.0.2" \
#      "build-tools;25.0.3" \
#      "build-tools;26.0.0" \
#      "build-tools;26.0.0-rc1" \
#      "build-tools;26.0.0-rc2" \
#      "build-tools;26.0.1" \
#      "build-tools;26.0.2" \
#      "build-tools;26.0.3" \
#      "build-tools;27.0.0" \
#      "build-tools;27.0.1" \
#      "build-tools;27.0.2" \
#      "build-tools;27.0.3" \
#      "build-tools;28.0.0" \
#      "build-tools;28.0.0-rc1" \
#      "build-tools;28.0.0-rc2" \
#      "build-tools;28.0.1" \
#      "build-tools;28.0.2" \
#      "build-tools;28.0.3" \
#      "build-tools;29.0.0" \
#      "build-tools;29.0.0-rc1" \
#      "build-tools;29.0.0-rc2" \
#      "build-tools;29.0.0-rc3" \
#      "build-tools;29.0.1" \
#      "build-tools;29.0.2" \
#      "build-tools;29.0.3" \
#      "build-tools;30.0.0" \
#      "build-tools;30.0.0-rc1" \
#      "build-tools;30.0.0-rc2" \
#      "build-tools;30.0.0-rc3" \
#      "build-tools;30.0.0-rc4" \
#      "build-tools;30.0.1" \
#      "build-tools;30.0.2" \
#      "build-tools;30.0.3" \
#      "build-tools;31.0.0" \
#      "build-tools;31.0.0-rc1" \
#      "build-tools;31.0.0-rc2" \
#      "build-tools;31.0.0-rc3" \
#      "build-tools;31.0.0-rc4" \
#      "build-tools;31.0.0-rc5" \
#      "build-tools;32.0.0" \
#      "build-tools;32.1.0-rc1" \
#      "build-tools;33.0.0" \
#      "build-tools;33.0.0-rc1" \
#      "build-tools;33.0.0-rc2" \
#      "build-tools;33.0.0-rc3" \
#      "build-tools;33.0.0-rc4" \
#      "build-tools;33.0.1" \
#      "build-tools;33.0.2" \
#      "build-tools;34.0.0" \
#      "build-tools;34.0.0-rc1" \
#      "build-tools;34.0.0-rc2" \
#      "build-tools;34.0.0-rc3" \
      "build-tools;34.0.0-rc4"

RUN sdkmanager --install \
      "cmake;3.10.2.4988404" \
      "cmake;3.18.1" \
      "cmake;3.22.1" \
      "cmake;3.6.4111459"

RUN sdkmanager --install \
#      "cmdline-tools;1.0" \
#      "cmdline-tools;1.0-alpha01" \
#      "cmdline-tools;10.0-beta04" \
#      "cmdline-tools;11.0-alpha07" \
#      "cmdline-tools;2.0" \
#      "cmdline-tools;2.0-rc01" \
#      "cmdline-tools;2.1" \
#      "cmdline-tools;3.0" \
#      "cmdline-tools;3.0-beta01" \
#      "cmdline-tools;4.0" \
#      "cmdline-tools;4.0-alpha02" \
#      "cmdline-tools;4.0-beta01" \
#      "cmdline-tools;5.0" \
#      "cmdline-tools;5.0-alpha01" \
#      "cmdline-tools;6.0" \
#      "cmdline-tools;7.0" \
#      "cmdline-tools;8.0" \
#      "cmdline-tools;9.0" \
      "cmdline-tools;latest"

RUN sdkmanager --install \
      "extras;android;m2repository" \
#      "extras;android;m2repository;01" \
#      "extras;android;m2repository;02" \
#      "extras;android;m2repository;03" \
#      "extras;android;m2repository;04" \
#      "extras;android;m2repository;06" \
#      "extras;android;m2repository;07" \
#      "extras;android;m2repository;08" \
#      "extras;android;m2repository;09" \
#      "extras;android;m2repository;1" \
#      "extras;android;m2repository;2" \
#      "extras;android;m2repository;3" \
#      "extras;android;m2repository;4" \
#      "extras;android;m2repository;6" \
#      "extras;android;m2repository;7" \
#      "extras;android;m2repository;8" \
#      "extras;android;m2repository;9" \
#      "extras;android;m2repository;10" \
#      "extras;android;m2repository;11" \
#      "extras;android;m2repository;12" \
#      "extras;android;m2repository;13" \
#      "extras;android;m2repository;14" \
#      "extras;android;m2repository;15" \
#      "extras;android;m2repository;16" \
#      "extras;android;m2repository;17" \
#      "extras;android;m2repository;18" \
#      "extras;android;m2repository;19" \
#      "extras;android;m2repository;20" \
#      "extras;android;m2repository;21" \
#      "extras;android;m2repository;22" \
#      "extras;android;m2repository;23" \
#      "extras;android;m2repository;24" \
#      "extras;android;m2repository;25" \
#      "extras;android;m2repository;26" \
#      "extras;android;m2repository;27" \
#      "extras;android;m2repository;28" \
#      "extras;android;m2repository;29" \
#      "extras;android;m2repository;30" \
#      "extras;android;m2repository;31" \
#      "extras;android;m2repository;32" \
#      "extras;android;m2repository;33" \
#      "extras;android;m2repository;34" \
#      "extras;android;m2repository;35" \
#      "extras;android;m2repository;36" \
#      "extras;android;m2repository;37" \
#      "extras;android;m2repository;38" \
#      "extras;android;m2repository;39" \
#      "extras;android;m2repository;40" \
#      "extras;android;m2repository;41" \
#      "extras;android;m2repository;42" \
#      "extras;android;m2repository;43" \
#      "extras;android;m2repository;44" \
#      "extras;android;m2repository;45" \
#      "extras;android;m2repository;46" \
      "extras;android;m2repository;47"

RUN sdkmanager --install \
      "platform-tools" \
#      "platform-tools;24.0.0" \
#      "platform-tools;29.0.5" \
#      "platform-tools;29.0.6" \
#      "platform-tools;30.0.0" \
#      "platform-tools;30.0.1" \
#      "platform-tools;30.0.2" \
#      "platform-tools;30.0.3" \
#      "platform-tools;30.0.4" \
#      "platform-tools;30.0.5" \
#      "platform-tools;31.0.0" \
#      "platform-tools;31.0.1" \
#      "platform-tools;31.0.2" \
#      "platform-tools;31.0.3" \
#      "platform-tools;32.0.0" \
#      "platform-tools;33.0.0" \
#      "platform-tools;33.0.1" \
#      "platform-tools;33.0.2" \
#      "platform-tools;33.0.3" \
#      "platform-tools;34.0.0" \
#      "platform-tools;34.0.1" \
      "platform-tools;34.0.3"

RUN sdkmanager --install \
#       "platforms;android-1" \
#       "platforms;android-2" \
#       "platforms;android-3" \
#       "platforms;android-4" \
#       "platforms;android-5" \
#       "platforms;android-6" \
#       "platforms;android-7" \
#       "platforms;android-8" \
#       "platforms;android-9" \
#       "platforms;android-10" \
#       "platforms;android-11" \
#       "platforms;android-12" \
#       "platforms;android-13" \
#       "platforms;android-14" \
#       "platforms;android-15" \
#       "platforms;android-16" \
#       "platforms;android-17" \
#       "platforms;android-18" \
#       "platforms;android-19" \
#       "platforms;android-20" \
#       "platforms;android-21" \
#       "platforms;android-22" \
#       "platforms;android-23" \
#       "platforms;android-24" \
#       "platforms;android-25" \
#       "platforms;android-26" \
#       "platforms;android-27" \
#       "platforms;android-28" \
#       "platforms;android-29" \
#       "platforms;android-30" \
#       "platforms;android-31" \
#       "platforms;android-32" \
#       "platforms;android-33" \
#       "platforms;android-34" \
       "platforms;android-35"

RUN sdkmanager --install \
#      "ndk-bundle;11.0.2655954" \
#      "ndk-bundle;11.1.2683735" \
#      "ndk-bundle;11.2.2725575" \
#      "ndk-bundle;12.0.2931149" \
#      "ndk-bundle;12.1.2977051" \
#      "ndk-bundle;13.0.3315539" \
#      "ndk-bundle;13.1.3345770" \
#      "ndk-bundle;14.0.3770861" \
#      "ndk-bundle;14.1.3816874" \
#      "ndk-bundle;15.0.4075724" \
#      "ndk-bundle;15.1.4119039" \
#      "ndk-bundle;15.2.4203891" \
#      "ndk-bundle;16.0.4442984" \
#      "ndk-bundle;16.1.4479499" \
#      "ndk-bundle;17.0.4754217" \
#      "ndk-bundle;17.1.4828580" \
#      "ndk-bundle;17.2.4988734" \
#      "ndk-bundle;18.1.5063045" \
#      "ndk-bundle;19.0.5232133" \
#      "ndk-bundle;19.1.5304403" \
#      "ndk-bundle;19.2.5345600" \
#      "ndk-bundle;20.0.5392854-beta2" \
#      "ndk-bundle;20.0.5471264-beta3" \
#      "ndk-bundle;20.0.5594570" \
#      "ndk-bundle;20.1.5948944" \
#      "ndk-bundle;21.0.6011959-beta2" \
#      "ndk-bundle;21.0.6113669" \
#      "ndk-bundle;21.1.6210238-beta1" \
#      "ndk-bundle;21.1.6273396-beta2" \
#      "ndk-bundle;21.1.6352462" \
#      "ndk-bundle;21.1.6363665-beta3" \
#      "ndk-bundle;21.2.6472646" \
#      "ndk-bundle;21.3.6528147" \
#      "ndk-bundle;21.4.7075529" \
#      "ndk-bundle;22.0.6917172-beta1" \
#      "ndk-bundle;22.0.7026061" \
#      "ndk-bundle;22.1.7171670" \
#      "ndk-bundle;23.0.7123448-beta1" \
#      "ndk-bundle;23.0.7196353-beta2" \
#      "ndk-bundle;23.0.7272597-beta3" \
#      "ndk-bundle;23.0.7344513-beta4" \
#      "ndk-bundle;23.0.7421159-beta5" \
#      "ndk-bundle;23.0.7530507-beta6" \
#      "ndk-bundle;23.0.7599858" \
#      "ndk-bundle;23.1.7779620" \
#      "ndk-bundle;23.2.8568313" \
#      "ndk-bundle;24.0.7856742-beta1" \
#      "ndk-bundle;24.0.7956693-beta2" \
#      "ndk-bundle;24.0.8079956-beta3" \
#      "ndk-bundle;24.0.8215888" \
#      "ndk-bundle;25.0.8141415-beta1" \
#      "ndk-bundle;25.0.8221429-beta2" \
#      "ndk-bundle;25.0.8355429-beta3" \
#      "ndk-bundle;25.0.8528842-beta4" \
#       "ndk-bundle;25.0.8775105" \
#       "ndk-bundle;25.1.8937393" \
       "ndk-bundle;25.2.9519653"

RUN sdkmanager --install \
#      "ndk-bundle;r10e" \
#      "ndk-bundle;r11" \
#      "ndk-bundle;r11b" \
#      "ndk-bundle;r11c" \
#      "ndk-bundle;r12" \
#      "ndk-bundle;r12b" \
#      "ndk-bundle;r13" \
#      "ndk-bundle;r13b" \
#      "ndk-bundle;r14" \
#      "ndk-bundle;r14b" \
#      "ndk-bundle;r15" \
#      "ndk-bundle;r15b" \
#      "ndk-bundle;r15c" \
#      "ndk-bundle;r16" \
#      "ndk-bundle;r16b" \
#      "ndk-bundle;r17" \
#      "ndk-bundle;r17b" \
#      "ndk-bundle;r17c" \
#      "ndk-bundle;r18b" \
#      "ndk-bundle;r19" \
#      "ndk-bundle;r19b" \
#      "ndk-bundle;r19c" \
#      "ndk-bundle;r20" \
#      "ndk-bundle;r20-beta2" \
#      "ndk-bundle;r20-beta3" \
#      "ndk-bundle;r20b" \
#      "ndk-bundle;r21" \
#      "ndk-bundle;r21-beta2" \
#      "ndk-bundle;r21b" \
#      "ndk-bundle;r21b-beta1" \
#      "ndk-bundle;r21b-beta2" \
#      "ndk-bundle;r21b-beta3" \
#      "ndk-bundle;r21c" \
#      "ndk-bundle;r21d" \
#      "ndk-bundle;r21e" \
#      "ndk-bundle;r22" \
#      "ndk-bundle;r22-beta1" \
#      "ndk-bundle;r22b" \
#      "ndk-bundle;r23" \
#      "ndk-bundle;r23-beta1" \
#      "ndk-bundle;r23-beta2" \
#      "ndk-bundle;r23-beta3" \
#      "ndk-bundle;r23-beta4" \
#      "ndk-bundle;r23-beta5" \
#      "ndk-bundle;r23-beta6" \
#      "ndk-bundle;r23b" \
#      "ndk-bundle;r23c" \
#      "ndk-bundle;r24" \
#      "ndk-bundle;r24-beta1" \
#      "ndk-bundle;r24-beta2" \
#      "ndk-bundle;r24-rc1" \
       "ndk-bundle;r25" \
#      "ndk-bundle;r25-beta1" \
#      "ndk-bundle;r25-beta2" \
#      "ndk-bundle;r25-beta3" \
#      "ndk-bundle;r25-beta4" \
#      "ndk-bundle;r25b" \
       "ndk-bundle;r25c"

RUN sdkmanager --install \
#      "ndk;11.0.2655954" \
#      "ndk;11.1.2683735" \
#      "ndk;11.2.2725575" \
#      "ndk;12.0.2931149" \
#      "ndk;12.1.2977051" \
#      "ndk;13.0.3315539" \
#      "ndk;13.1.3345770" \
#      "ndk;14.0.3770861" \
#      "ndk;14.1.3816874" \
#      "ndk;15.0.4075724" \
#      "ndk;15.1.4119039" \
#      "ndk;15.2.4203891" \
#      "ndk;16.0.4442984" \
#      "ndk;16.1.4479499" \
#      "ndk;17.0.4754217" \
#      "ndk;17.1.4828580" \
#      "ndk;17.2.4988734" \
#      "ndk;18.1.5063045" \
#      "ndk;19.0.5232133" \
#      "ndk;19.1.5304403" \
#      "ndk;19.2.5345600" \
#      "ndk;20.0.5392854-beta2" \
#      "ndk;20.0.5471264-beta3" \
#      "ndk;20.0.5594570" \
#      "ndk;20.1.5948944" \
#      "ndk;21.0.6011959-beta2" \
#      "ndk;21.0.6113669" \
#      "ndk;21.1.6210238-beta1" \
#      "ndk;21.1.6273396-beta2" \
#      "ndk;21.1.6352462" \
#      "ndk;21.1.6363665-beta3" \
#      "ndk;21.2.6472646" \
#      "ndk;21.3.6528147" \
#      "ndk;21.4.7075529" \
#      "ndk;22.0.6917172-beta1" \
#      "ndk;22.0.7026061" \
#      "ndk;22.1.7171670" \
#      "ndk;23.0.7123448-beta1" \
#      "ndk;23.0.7196353-beta2" \
#      "ndk;23.0.7272597-beta3" \
#      "ndk;23.0.7344513-beta4" \
#      "ndk;23.0.7421159-beta5" \
#      "ndk;23.0.7530507-beta6" \
#      "ndk;23.0.7599858" \
#      "ndk;23.1.7779620" \
#      "ndk;23.2.8568313" \
#      "ndk;24.0.7856742-beta1" \
#      "ndk;24.0.7956693-beta2" \
#      "ndk;24.0.8079956-beta3" \
#      "ndk;24.0.8215888" \
#      "ndk;25.0.8141415-beta1" \
#      "ndk;25.0.8221429-beta2" \
#      "ndk;25.0.8355429-beta3" \
#      "ndk;25.0.8528842-beta4" \
#       "ndk;25.0.8775105" \
#       "ndk;25.1.8937393" \
       "ndk;25.2.9519653"

RUN sdkmanager --install \
#      "ndk;r10e" \
#      "ndk;r11" \
#      "ndk;r11b" \
#      "ndk;r11c" \
#      "ndk;r12" \
#      "ndk;r12b" \
#      "ndk;r13" \
#      "ndk;r13b" \
#      "ndk;r14" \
#      "ndk;r14b" \
#      "ndk;r15" \
#      "ndk;r15b" \
#      "ndk;r15c" \
#      "ndk;r16" \
#      "ndk;r16b" \
#      "ndk;r17" \
#      "ndk;r17b" \
#      "ndk;r17c" \
#      "ndk;r18b" \
#      "ndk;r19" \
#      "ndk;r19b" \
#      "ndk;r19c" \
#      "ndk;r20" \
#      "ndk;r20-beta2" \
#      "ndk;r20-beta3" \
#      "ndk;r20b" \
#      "ndk;r21" \
#      "ndk;r21-beta2" \
#      "ndk;r21b" \
#      "ndk;r21b-beta1" \
#      "ndk;r21b-beta2" \
#      "ndk;r21b-beta3" \
#      "ndk;r21c" \
#      "ndk;r21d" \
#      "ndk;r21e" \
#      "ndk;r22" \
#      "ndk;r22-beta1" \
#      "ndk;r22b" \
#      "ndk;r23" \
#      "ndk;r23-beta1" \
#      "ndk;r23-beta2" \
#      "ndk;r23-beta3" \
#      "ndk;r23-beta4" \
#      "ndk;r23-beta5" \
#      "ndk;r23-beta6" \
#      "ndk;r23b" \
#      "ndk;r23c" \
#      "ndk;r24" \
#      "ndk;r24-beta1" \
#      "ndk;r24-beta2" \
#      "ndk;r24-rc1" \
       "ndk;r25" \
#      "ndk;r25-beta1" \
#      "ndk;r25-beta2" \
#      "ndk;r25-beta3" \
#      "ndk;r25-beta4" \
#      "ndk;r25b" \
       "ndk;r25c"

RUN sdkmanager --install \
      "tools" \
#      "tools;20.0.1" \
#      "tools;20.0.3" \
#      "tools;21.0.1" \
#      "tools;22.0.1" \
#      "tools;22.0.4" \
#      "tools;22.0.5" \
#      "tools;22.2.1" \
#      "tools;22.6.1" \
#      "tools;22.6.2" \
#      "tools;22.6.3" \
#      "tools;22.6.4" \
#      "tools;23.0.1" \
#      "tools;23.0.2" \
#      "tools;23.0.4" \
#      "tools;23.0.5" \
#      "tools;24.0.1" \
#      "tools;24.0.2" \
#      "tools;24.1.2" \
#      "tools;24.3.1" \
#      "tools;24.3.2" \
#      "tools;24.3.3" \
#      "tools;24.3.4" \
#      "tools;24.4.1" \
#      "tools;25.0.1" \
#      "tools;25.0.2" \
#      "tools;25.0.3" \
#      "tools;25.0.4" \
#      "tools;25.0.5" \
#      "tools;25.0.6" \
#      "tools;25.0.7" \
#      "tools;25.0.8" \
#      "tools;25.0.9" \
#      "tools;25.1.0" \
#      "tools;25.1.1" \
#      "tools;25.1.2" \
#      "tools;25.1.3" \
#      "tools;25.1.4" \
#      "tools;25.1.5" \
#      "tools;25.1.6" \
#      "tools;25.1.7" \
#      "tools;25.2.1" \
#      "tools;25.2.2" \
#      "tools;25.2.3" \
#      "tools;25.2.4" \
#      "tools;25.2.5" \
      "tools;25.2.5"
#      "tools;26.1.1"

# Activate android sdk
#RUN echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > /usr/lib/android-sdk/licenses/android-sdk-license
#RUN rm -rfv /usr/lib/android-sdk/licenses/*
RUN yes | sdkmanager --licenses
RUN ln -fs $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/screenshot2 $ANDROID_SDK_ROOT/tools/bin/screenshot2

##################################################################
#                   cleaninig up
##################################################################
RUN apt clean -y && \
    apt-get clean all && \
    apt autoclean -y && \
    rm -rfv /var/lib/apt/lists/* && \
    rm -rfv /var/cache/apt/* && \
    rm -rfv /root/tmp/* && \
    rm -rfv /tmp/*

RUN updatedb
