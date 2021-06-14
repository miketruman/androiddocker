FROM ubuntu:20.04

ENV ANDROID_SDK_HOME /usr/lib/android-sdk
ENV ANDROID_SDK_ROOT /usr/lib/android-sdk
ENV ANDROID_HOME /usr/lib/android-sdk
ENV ANDROID_SDK /usr/lib/android-sdk

ENV PATH "${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/tools/bin:${ANDROID_HOME}/emulator:${ANDROID_HOME}/bin"

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && apt-get update -yqq && apt-get install -y \
  curl \
  expect \
  git \
  libc6:i386 \
  libgcc1:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  zlib1g:i386 \
  openjdk-8-jdk \
  wget \
  unzip \
  vim \
  telnet tshark \
  iputils-ping python3 python3-pip net-tools tcpdump \
  && apt-get clean

RUN pip3 install pure-python-adb requests pyshark

RUN touch /root/.emulator_console_auth_token

RUN mkdir /usr/lib/android-sdk/
RUN mkdir /usr/lib/android-sdk/cmdline-tools
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip
RUN unzip commandlinetools-linux-6609375_latest.zip -d /usr/lib/android-sdk/cmdline-tools 

RUN yes | sdkmanager --licenses


RUN sdkmanager "platform-tools"
RUN sdkmanager "emulator"
RUN sdkmanager "build-tools;30.0.0"
RUN sdkmanager "platforms;android-25"
RUN sdkmanager --install "system-images;android-25;google_apis;x86_64"
WORKDIR ${ANDROID_HOME}
RUN echo "no" | avdmanager --verbose create avd --force --name "generic_10" --package "system-images;android-25;google_apis;x86_64"
CMD ["emulator", "-avd", "generic_10", "-wipe-data","-memory", "2048" ]
