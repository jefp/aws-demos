FROM ubuntu:16.04

ARG APP_PATH
ARG APP_GROUP
ARG APP_USER
ARG RUBY_VERSION
ARG APPGEMSET

RUN mkdir -p $APP_PATH
COPY . $APP_PATH

RUN groupadd -f $APP_GROUP

RUN  if ! getent passwd $APP_USER > /dev/null 2>&1; then useradd -g $APP_GROUP $APP_USER -s /bin/bash ; fi

RUN chown -R $APP_USER:$APP_GROUP $APP_PATH
RUN rm -rf  $APP_PATH/logs/* $APP_PATH/tmp/* /tmp/*

RUN su - $APP_USER -c "curl -sSL https://get.rvm.io | bash -s stable"
RUN su - $APP_USER -c "rvm install $RUBY_VERSION"
RUN su - $APP_USER -c "rvm use $RUBY_VERSION && rvm gemset create $APPGEMSET"

RUN su - $APP_USER -c "rvm gemset use $APPGEMSET && cd $APP_PATH && bundle install --without test development"

#Remove any apt-get data
RUN  rm -rf /var/lib/apt/lists/*
