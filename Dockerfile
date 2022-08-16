ARG base_image=ghcr.io/alphagov/govuk-ruby-base:2.7.6
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:2.7.6
 
FROM $builder_image AS builder

RUN mkdir /app

WORKDIR /app

COPY Gemfile* .ruby-version /app/

RUN bundle install

COPY . /app
# TODO: We probably don't want assets in the image; remove this once we have a proper deployment process which uploads to (e.g.) S3.
RUN bundle exec rails assets:precompile && rm -rf /app/log


FROM $base_image

ENV GOVUK_APP_NAME=government-frontend

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app/

USER app
WORKDIR /app

CMD bundle exec puma
