ARG base_image=ghcr.io/alphagov/govuk-ruby-base:3.1.2
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:3.1.2

FROM $builder_image AS builder

WORKDIR /app

COPY Gemfile* .ruby-version ./
RUN bundle install

COPY . /app
RUN bundle exec rails assets:precompile && rm -rf /app/log


FROM $base_image

# TODO: remove PORT and set it in publishing-e2e-tests instead.
ENV GOVUK_APP_NAME=government-frontend PORT=3090

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app /app/

USER app
WORKDIR /app

CMD ["bundle", "exec", "puma"]
