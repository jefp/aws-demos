


RUN mkdir -p $APP_PATH

COPY . $APP_PATH

RUN chown -R $APP_USER:$APP_GROUP $APP_PATH

RUN su - $APP_USER -c "rvm gemset use $APP_GEMSET && cd $APP_PATH && bundle install --without test development"

RUN rm -rf  $APP_PATH/logs/* $APP_PATH/tmp/* /tmp/*

#Remove any apt-get data
RUN  rm -rf /var/lib/apt/lists/*
