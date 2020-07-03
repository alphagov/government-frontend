source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "asset_bom_removal-rails"
gem "dalli"
gem "gds-api-adapters"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_publishing_components"
gem "htmlentities"
gem "plek"
gem "rack_strip_client_ip"
gem "rails", "~> 5.2.4"
gem "rails-controller-testing"
gem "rails-i18n"
gem "rails_translation_manager"
gem "sass-rails"
gem "slimmer"
gem "uglifier"

group :development, :test do
  gem "govuk_schemas"
  gem "jasmine-rails"
  gem "rubocop-govuk"
  gem "scss_lint-govuk"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry"
  gem "wraith"
end

group :test do
  gem "capybara"
  gem "faker"
  gem "govuk_test"
  gem "minitest-reporters"
  gem "mocha"
  gem "webmock", require: false
end
