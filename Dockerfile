FROM diko316/debnode:latest

# change the path to /opt/app when using this image
ENV GULP_SOURCE $PROJECT_ROOT
ENV APP_RUNNER $APP_TOOLS/gulp/start.sh
ENV APP_OBSERVE $PROJECT_ROOT/gulpfile.js

# add gulp tools
ADD ./tools $APP_TOOLS

# install globals
RUN mkdir -p /tmp
ADD ./package.json /tmp
WORKDIR /tmp

RUN npm install -g -ddd gulp bower && \
        npm install -ddd && \
        cp -a /tmp/node_modules $PROJECT_ROOT
        

# package install dev tools
WORKDIR $GULP_SOURCE

# same as base image, just changed the APP_RUNNER
CMD $APP_TOOLS/watcher/start.sh
