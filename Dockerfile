FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV GULP_SOURCE=$PROJECT_ROOT APP_PRERUNNER=$APP_TOOLS/gulp/pre-start.sh APP_RUNNER=$APP_TOOLS/gulp/start.sh APP_OBSERVE=$PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# install globals
ADD package.json /tmp/package.json

RUN "$APP_TOOLS/installer/npminstall.sh" \
        --apt \
            build-essential \
        --global \
            gulp \
            browser-sync

# package install dev tools
WORKDIR $GULP_SOURCE

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
