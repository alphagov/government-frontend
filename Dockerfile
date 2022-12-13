ARG base_image=ghcr.io/alphagov/govuk-ruby-base:3.1.2
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:3.1.2

FROM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY . ./
RUN bundle exec bootsnap precompile --gemfile .
RUN bundle exec rails assets:precompile && rm -rf log


FROM $base_image

ENV GOVUK_APP_NAME=government-frontend

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH/ $BUNDLE_PATH/
COPY --from=builder $BOOTSNAP_CACHE_DIR/ $BOOTSNAP_CACHE_DIR/
COPY --from=builder $APP_HOME ./

USER app
CMD ["puma"]
