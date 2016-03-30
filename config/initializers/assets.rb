# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  application-ie6.css
  application-ie7.css
  application-ie8.css
)

# Precompile js
Rails.application.config.assets.precompile += %w(
  govuk/modules.js
  modules/accordion-with-descriptions.js
  start-modules.js
)
