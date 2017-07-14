

ARG APP_PATH
ARG APP_USER
ARG APP_GROUP
ARG APP_GEMSET


RUN mkdir -p $APP_PATH

COPY . $APP_PATH

RUN chown -R $APP_USER:$APP_GROUP $APP_PATH

RUN su - $APP_USER -c " cd $APP_PATH && rvm gemset use $APP_GEMSET && bundle install --without test development"

RUN su - $APP_USER -c " cd $APP_PATH && rvm gemset use $APP_GEMSET && RAILS_ENV=production rake assets:precompile"


RUN rm -rf  $APP_PATH/logs/* $APP_PATH/tmp/* /tmp/*

#Remove any apt-get data
RUN  rm -rf /var/lib/apt/lists/*

USER $APP_USER

WORKDIR $APP_PATH

ENTRYPOINT ["/bin/bash", "--login","-c"]

CMD ["rvm gemset use myapp && cd /mnt/myapp/ && SECRET_KEY_BASE=$SECRET_KEY_BASE puma -e production -v -w 2  -p 3000"]
