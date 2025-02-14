FROM ruby:3.4.1-alpine

RUN apk add --no-cache build-base bash nodejs npm yarn sqlite sqlite-dev tzdata git

WORKDIR /app

RUN gem install rails -v 8.0.1

EXPOSE 3000

CMD ["bash"]
