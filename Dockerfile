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

RUN apt-get update && apt-get upgrade -y && apt-get install -y libpq-dev ssmtp ca-certificates sudo dirmngr nodejs libcurl3 curl git iputils-ping nginx-extras vim net-tools telnet wget

RUN apt-get install -y  python-software-properties 

RUN apt-add-repository -y ppa:rael-gc/rvm
RUN apt-get update
RUN apt-get install -y rvm


RUN echo "APP_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-$APP_USER

RUN su - $APP_USER -c "rvm install $RUBY_VERSION"
RUN su - $APP_USER -c "rvm use $RUBY_VERSION && rvm gemset create $APPGEMSET"

RUN su - $APP_USER -c "rvm gemset use $APPGEMSET && cd $APP_PATH && bundle install --without test development"

#Remove any apt-get data
RUN  rm -rf /var/lib/apt/lists/*
