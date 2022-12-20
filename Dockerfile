FROM jetbrains/teamcity-agent:latest

MAINTAINER Tweak4141

ENV GRADLE_HOME=/usr/bin/gradle
ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update
RUN apt-get install -y --force-yes expect git mc gradle unzip \
    wget curl libc6-i386 lib32stdc++6 lib32gcc1 \
    lib32ncurses6 lib32z1
RUN apt-get clean
#RUN rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD android-accept-licenses.sh /opt/tools/
ENV PATH ${PATH}:/opt/tools
ENV LICENSE_SCRIPT_PATH /opt/tools/android-accept-licenses.sh

RUN cd /opt && wget --output-document=android-tools.zip \
    https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip && \
    unzip android-tools.zip -d android-sdk-linux && \
    chown -R root.root android-sdk-linux

ENV ANDROID_SDK_ROOT "/opt/android-sdk-linux"
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/build-tools

RUN sdkmanager --update --sdk_root=${ANDROID_SDK_ROOT} && \
    yes | sdkmanager --licenses && \
    sdkmanager "build-tools;33.0.1" "platforms;android-31" "platform-tools" --sdk_root=${ANDROID_SDK_ROOT}
