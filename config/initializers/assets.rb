# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w[webchat/library.js webchat.js]

# This manifest from govuk_publishing_components references css files which
# means it is not compatible with dartsass-rails
#
# By removing this it means we lose images and fonts from govuk_publishing_components
#
# https://github.com/rails/dartsass-rails#troubleshooting
Rails.application.config.assets.precompile -= %w[govuk_publishing_components_manifest.js]
