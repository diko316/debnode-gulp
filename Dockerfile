FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV GULP_SOURCE=$PROJECT_ROOT APP_PRERUNNER=$APP_TOOLS/gulp/pre-start.sh APP_RUNNER=$APP_TOOLS/gulp/start.sh APP_OBSERVE=$PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# autobuild gulp stack
RUN "$APP_TOOLS/autobuild.sh" gulp

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
