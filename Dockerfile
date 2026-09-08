FROM ruby:3.3

WORKDIR /srv/jekyll

COPY Gemfile ./

RUN bundle lock --add-platform x86_64-linux
RUN bundle install

VOLUME /srv/jekyll
