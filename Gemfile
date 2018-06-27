source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'asset_bom_removal-rails', '~> 1.0'
gem 'dalli'
gem 'htmlentities', '~> 4.3'
gem 'rack_strip_client_ip', '~> 0.0.2'
gem 'rails', '~> 5.2.0'
gem 'rails-controller-testing', '~> 1.0'
gem 'rails-i18n', '>= 4.0.4'
gem 'rails_translation_manager', '~> 0.0.2'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'gds-api-adapters', '~> 52.6'
gem 'govuk_ab_testing', '~> 2.4'
gem 'govuk_app_config', '~> 1.5'
gem 'govuk_frontend_toolkit', '~> 7.4'
gem 'govuk_publishing_components', '~> 9.3.6'
gem 'plek', '~> 2.1'
gem 'slimmer', '~> 13.0'

group :development, :test do
  gem 'govuk-lint'
  gem 'govuk_schemas', '~> 3.1'
  gem 'jasmine-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'wraith', '~> 4.2'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'mocha'
  gem 'poltergeist', require: false
  gem 'webmock', '~> 3.4.2', require: false
end
