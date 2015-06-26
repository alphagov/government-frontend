source 'https://rubygems.org'

gem 'airbrake', '4.0'
gem 'govuk_frontend_toolkit', '2.0.1'
gem 'logstasher', '0.6.1'
gem 'plek', '1.9'
gem 'rails', '4.1.11'
gem 'sass-rails', '~> 4.0.3'
gem 'slimmer', '8.2.1'
gem 'uglifier', '>= 1.3.0'
gem 'unicorn', '4.8'
gem 'rails-i18n', '>= 4.0.4'
gem 'rails_translation_manager', '~> 0.0.2'

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '20.0.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'webmock', '~> 1.18.0', :require => false
  gem 'govuk-content-schema-test-helpers', '1.1.0'
end

