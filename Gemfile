source "https://rubygems.org"

ruby "~> 3.4.5"

gem "rails", "8.1.1"

gem "bootsnap", require: false
gem "dalli"
gem "dartsass-rails"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_personalisation"
gem "govuk_publishing_components", "64.0.0"
gem "govuk_web_banners"
gem "htmlentities"
gem "plek"
gem "rack-utf8_sanitizer"
gem "rails-controller-testing"
gem "rails-i18n"
gem "rails_translation_manager"
gem "rinku", require: "rails_rinku"
gem "rss"
gem "sprockets-rails"
gem "terser"

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
  gem "minitest", "5.27.0"
  gem "minitest-reporters"
  gem "mocha"
  gem "shoulda-context"
  gem "simplecov"
  gem "timecop"
  gem "webmock", require: false
end
