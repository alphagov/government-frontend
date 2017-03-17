require 'capybara/poltergeist'
require 'phantomjs/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
