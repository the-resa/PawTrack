FROM ruby:3.4.1-alpine

RUN apk add --no-cache build-base bash nodejs npm yarn sqlite sqlite-dev tzdata curl

WORKDIR /tmp
COPY Gemfile* /tmp/

RUN gem update bundler && \
  bundle update --bundler && \
  bundle install

ADD scripts/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

WORKDIR /app
COPY . /app

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
