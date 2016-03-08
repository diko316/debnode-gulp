FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV GULP_SOURCE $PROJECT_ROOT
ENV APP_PRERUNNER $APP_TOOLS/gulp/pre-start.sh
ENV APP_RUNNER $APP_TOOLS/gulp/start.sh
ENV APP_OBSERVE $PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# install globals
ADD package.json /tmp/package.json
WORKDIR /tmp

RUN apt-get update && \
    apt-get install -y build-essential && \
    npm install -g -ddd gulp bower browser-sync && \
        npm install -ddd && \
        cp -a /tmp/node_modules $PROJECT_ROOT && \
    apt-get purge -y build-essential && \
    apt-get autoremove -y && \
    dpkg --purge $(dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2) && \
    rm -rf /usr/include \
        /usr/share/man \
        /tmp/* \
        /var/cache/apt/* \
        /root/.npm \
        /root/.node-gyp \
        /usr/lib/node_modules/npm/man \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html \
        /var/lib/apt/lists/*

# package install dev tools
WORKDIR $GULP_SOURCE

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
