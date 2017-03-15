FROM ruby:2.3.1
RUN apt-get update -qq && apt-get upgrade -y

RUN apt-get install -y build-essential && apt-get clean

ENV GOVUK_APP_NAME government-frontend
ENV GOVUK_ASSET_ROOT http://assets-origin.dev.gov.uk
ENV PORT 3090
ENV RAILS_ENV development

ENV APP_HOME /app
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
ADD .ruby-version $APP_HOME/
RUN bundle install

ADD . $APP_HOME

CMD bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p $PORT -b '0.0.0.0'"
