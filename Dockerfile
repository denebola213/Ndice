FROM ruby:2.7

ENV LANG C.UTF-8

RUN bundle config --global frozen 1

WORKDIR /usr/src/app

# install library
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["ruby", "./run.rb"]
