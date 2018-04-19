# https://github.com/gollum/gollum/wiki/Gollum-via-Docker
FROM ruby:alpine

MAINTAINER Niklas Lindblad <niklas@lindblad.info>

# Building the environment
RUN apk add --update --virtual build-deps build-base icu-dev \
    && apk add --update icu-libs git bash cmake

# Building Gollum
RUN cd /usr/ \
    &&  git clone https://github.com/gollum/gollum.git  \
    && cd /usr/gollum \
    && git checkout v4.1.0

RUN cd /usr/gollum \
    && bundle install \
    && rake build

RUN cd /usr/gollum \
    && gem install github-linguist \
    && gem install --no-document pkg/gollum*.gem

COPY auth.rb /auth.rb

# Gollun run configuration
WORKDIR /wiki
ENTRYPOINT ["gollum", "--port", "4567", "--config", "/auth.rb"]
EXPOSE 4567
