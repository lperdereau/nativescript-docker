FROM ubuntu:latest

RUN useradd -ms /bin/bash nativescript

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Utilities
RUN apt-get update && \
    apt-get -y install apt-transport-https unzip curl usbutils --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# JAVA
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
    apt-get update && \
    apt-get -y install nodejs --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NativeScript
RUN npm install -g nativescript && \
    tns error-reporting disable

# Android build requirements
RUN apt-get update && \
    apt-get -y install lib32stdc++6 lib32z1 --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Android SDK
ENV VERSION_SDK_TOOLS=3952940 \
	  ANDROID_HOME=/opt/android-sdk
ENV	PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
RUN apt-get update && apt-get install unzip && \
    mkdir -p $ANDROID_HOME && \
    chown -R root.root $ANDROID_HOME && \
    curl http://dl.google.com/android/repository/sdk-tools-linux-$VERSION_SDK_TOOLS.zip -o sdk.zip && \
    unzip sdk.zip -d $ANDROID_HOME && \
    rm -f sdk.zip
RUN echo $ANDROID_HOME
RUN mkdir -p /root/.android && \
    touch /root/.android/repositories.cfg
    
RUN yes | sdkmanager --licenses && sdkmanager --update

RUN yes | sdkmanager \
  "tools" \
  "platform-tools" \
  "build-tools;28.0.3" \
  "extras;android;m2repository" \
  "platforms;android-28" \
  "extras;google;m2repository"

RUN mkdir /app /dist && \
    chown nativescript:nativescript /opt/android-sdk /app /dist
USER nativescript
RUN tns error-reporting disable
# Self-update of 'tools' package is currently not working?
#RUN echo "y" | /opt/android-sdk/tools/android --silent update sdk -a -u -t tools

VOLUME ["/app","/dist"]

WORKDIR /app

CMD ["/docker-entrypoint.sh"]