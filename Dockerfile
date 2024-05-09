FROM redis:latest

RUN apt-get update && \
    apt-get install -y ruby && \
    gem install redis  && \
    gem install beanstalk-client && \
    gem install pry

WORKDIR /scripts

COPY put_message_into_beanstalkd.rb /scripts/put_message_into_beanstalkd.rb
COPY redis_test.rb /scripts/redis_test.rb
COPY pub_sub_redis_test.rb /scripts/pub_sub_redis_test.rb