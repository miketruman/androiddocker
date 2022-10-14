FROM ubuntu:22.10

ENV ANDROID_SDK_HOME /usr/lib/android-sdk
ENV ANDROID_SDK_ROOT /usr/lib/android-sdk
ENV ANDROID_HOME /usr/lib/android-sdk
ENV ANDROID_SDK /usr/lib/android-sdk

ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/bin"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y wget unzip
RUN touch /root/.emulator_console_auth_token

RUN mkdir /usr/lib/android-sdk/
RUN mkdir /usr/lib/android-sdk/cmdline-tools
RUN mkdir /usr/lib/android-sdk/cmdline-tools/tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
RUN unzip commandlinetools-linux-8512546_latest.zip  -d /usr/lib/android-sdk/tmp
RUN mv /usr/lib/android-sdk/tmp/cmdline-tools/* /usr/lib/android-sdk/cmdline-tools/tools

RUN apt-get install -y openjdk-8-jdk
RUN yes | sdkmanager --licenses

RUN sdkmanager "emulator"
RUN sdkmanager "platform-tools"
ARG ABIS
ARG ANDROID
RUN export
RUN sdkmanager --install "system-images;$ANDROID;$ABIS;x86_64"
RUN sdkmanager "platforms;$ANDROID"
RUN sdkmanager --list --verbose |grep google_apis |grep x86_64
WORKDIR ${ANDROID_HOME}
RUN touch /usr/lib/android-sdk/.android/emu-update-last-check.ini
ENV ANDROID_EMULATOR_WAIT_TIME_BEFORE_KILL 2
RUN adb keygen .android/adbkey
ENV ADB_VENDOR_KEYS=/root/.android/adbkey
RUN apt-get install -y tzdata telnet vim
RUN echo no | avdmanager create avd -f -n generic_10 -c 128M --device "pixel_xl" --abi $ABIS/x86_64 -k "system-images;$ANDROID;$ABIS;x86_64"
CMD ["emulator", "-avd", "generic_10","-noaudio", "-skip-adb-auth","-memory", "4096"]

