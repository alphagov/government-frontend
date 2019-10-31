source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "asset_bom_removal-rails", "~> 1.0"
gem "dalli"
gem "gds-api-adapters", "~> 60.0"
gem "govuk_ab_testing", "~> 2.4"
gem "govuk_app_config", "~> 2.0"
gem "govuk_frontend_toolkit", "~> 8.2.0"
gem "govuk_publishing_components", "~> 21.8.0"
gem "htmlentities", "~> 4.3"
gem "plek", "~> 3.0"
gem "rack_strip_client_ip", "~> 0.0.2"
gem "rails", "~> 5.2.3"
gem "rails-controller-testing", "~> 1.0"
gem "rails-i18n", ">= 4.0.4"
gem "rails_translation_manager", "~> 0.1.0"
gem "sass-rails", "~> 5.0"
gem "slimmer", "~> 13.2"
gem "uglifier", ">= 1.3.0"

group :development, :test do
  gem "govuk-lint"
  gem "govuk_schemas", "~> 4.0"
  gem "jasmine-rails"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry"
  gem "wraith", "~> 4.2"
end

group :test do
  gem "capybara"
  gem "faker"
  gem "govuk_test"
  gem "minitest-reporters"
  gem "mocha"
  gem "webmock", "~> 3.7.6", require: false
end
