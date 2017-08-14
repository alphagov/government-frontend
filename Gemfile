source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'airbrake', github: 'alphagov/airbrake', branch: 'silence-dep-warnings-for-rails-5'
gem 'asset_bom_removal-rails', '~> 1.0.0'
gem 'dalli'
gem 'gds-api-adapters', '~> 43.0'
gem 'govuk_ab_testing', '~> 2.0'
gem 'govuk_frontend_toolkit', '5.1.0'
gem 'govuk_publishing_components', '~> 0.5.0', require: ENV['RAILS_ENV'] != "production" || ENV['HEROKU_APP_NAME'].to_s.length.positive?
gem 'htmlentities', '4.3.4'
gem 'logstasher', '0.6.1'
gem 'plek', '1.11'
gem 'rack_strip_client_ip', '~> 0.0.2'
gem 'rails', '~> 5.0.5'
gem 'rails-controller-testing', '~> 0.1'
gem 'rails-i18n', '>= 4.0.4'
gem 'rails_translation_manager', '~> 0.0.2'
gem 'sass-rails', '~> 5.0.4'
gem 'slimmer', github: 'alphagov/slimmer', branch: 'raise-error'
gem 'statsd-ruby', '1.3.0', require: 'statsd'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '4.8'

gem 'govuk_navigation_helpers', '~> 6.3'

group :development, :test do
  gem 'govuk-lint'
  gem 'govuk_schemas'
  gem 'jasmine-rails', github: 'alphagov/jasmine-rails', branch: 'fix-monkey-patch'
  gem 'pry-byebug'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'wraith', '~> 4.0'
end

group :test do
  gem 'capybara'
  gem 'mocha'
  gem 'poltergeist', require: false
  gem 'webmock', '~> 1.18.0', require: false
end
