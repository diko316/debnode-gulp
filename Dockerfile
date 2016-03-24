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

RUN "$APP_TOOLS/installer/install.sh" \
        build-essential && \
    cd "/tmp" && \
    npm install -g -ddd gulp bower browser-sync && \
        npm install -ddd && \
        cp -a /tmp/node_modules $PROJECT_ROOT && \
    "$APP_TOOLS/installer/uninstall.sh" \
        build-essential && \
    rm -rf /root/.node-gyp && \
    "$APP_TOOLS/installer/cleanup.sh"

# package install dev tools
WORKDIR $GULP_SOURCE

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
