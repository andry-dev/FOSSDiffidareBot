FROM ruby:alpine

RUN apk add --no-cache build-base git

COPY . /app
WORKDIR /app
RUN bundle install

CMD ["ruby", "main.rb"]
