source "https://rubygems.org"

ruby "~> 3.2.0"

gem "rails", "7.1.3"

gem "bootsnap", require: false
gem "dalli"
gem "dartsass-rails"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_personalisation"
gem "govuk_publishing_components", git: "https://github.com/alphagov/govuk_publishing_components.git", branch: "spike-font-size-changes-2"
gem "htmlentities"
gem "plek"
gem "rails-controller-testing"
gem "rails-i18n"
gem "rails_translation_manager"
gem "rinku", require: "rails_rinku"
gem "rss"
gem "slimmer"
gem "sprockets-rails"
gem "uglifier"

group :development, :test do
  gem "govuk_schemas"
  gem "govuk_test"
  gem "pry-byebug"
  gem "rubocop-govuk"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem "capybara"
  gem "climate_control"
  gem "faker"
  gem "i18n-coverage"
  gem "minitest-reporters"
  gem "mocha"
  gem "shoulda-context"
  gem "simplecov"
  gem "timecop"
  gem "webmock", require: false
end
