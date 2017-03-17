source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'airbrake', '~> 5.5'
gem 'airbrake-ruby', '1.5'

gem 'govuk_frontend_toolkit', '5.1.0'
gem 'logstasher', '0.6.1'
gem 'plek', '1.11'
gem 'rails', '~> 5.0'
gem 'sass-rails', '~> 5.0.4'
if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 10.1.3'
end
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '4.8'
gem 'rails-i18n', '>= 4.0.4'
gem 'rails_translation_manager', '~> 0.0.2'
gem 'rails-controller-testing', '~> 0.1'
gem 'govuk_ab_testing', '1.0.1'
gem 'htmlentities', '4.3.4'
gem 'statsd-ruby', '1.3.0', require: 'statsd'

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 40.1'
end

gem 'govuk_navigation_helpers', '~> 4.0'

group :development, :test do
  gem 'govuk_schemas'
  gem 'govuk-lint'
  gem 'pry-byebug'
  gem 'jasmine-rails', '~> 0.14.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'capybara'
  gem 'webmock', '~> 1.18.0', require: false
  gem 'govuk-content-schema-test-helpers', '1.1.0'
  gem 'mocha'
  gem 'poltergeist', require: false
  gem 'phantomjs'
end
