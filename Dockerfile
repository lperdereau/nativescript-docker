FROM runmymind/docker-android-sdk:ubuntu-standalone

RUN mkdir /dist
WORKDIR /dist

# Installs Node.js
ENV NODE_VERSION 13.3.0
RUN cd && \
    wget -q http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz && \
    tar -xzf node-v${NODE_VERSION}-linux-x64.tar.gz && \
    mv node-v${NODE_VERSION}-linux-x64 /opt/node && \
    rm node-v${NODE_VERSION}-linux-x64.tar.gz
ENV PATH ${PATH}:/opt/node/bin

# Installs nativescript
RUN npm install -g nativescript --unsafe-perm
RUN npm install nativescript --unsafe-perm
# installs android platform
RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" "platforms;android-25" "build-tools;25.0.2" "extras;android;m2repository" "extras;google;m2repository"

