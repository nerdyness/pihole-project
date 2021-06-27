FROM ruby:3
WORKDIR /app
RUN echo "Europe/Oslo" > /etc/timezone && cp /usr/share/zoneinfo/`cat /etc/timezone` /etc/localtime
RUN gem install pry
ADD Gemfile* ./
RUN bundle install
ADD app.rb ./
CMD ["/app/app.rb"]
ENV API_TOKEN "set me"
ENV AWS_ACCESS_KEY_ID "set me"
ENV AWS_SECRET_ACCESS_KEY "set me"
ENV AWS_DEFAULT_REGION "set me"
