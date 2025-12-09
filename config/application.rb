require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"
require_relative "../lib/sanitiser/strategy"

require "govuk_publishing_components/middleware/ga4_optimise"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovernmentFrontend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks sanitiser])

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W[#{config.root}/lib/helpers]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Explicitly set available locales
    config.i18n.available_locales = %i[
      en
      ar
      az
      be
      bg
      bn
      cs
      cy
      da
      de
      dr
      el
      es
      es-419
      et
      fa
      fi
      fr
      gd
      gu
      he
      hi
      hr
      hu
      hy
      id
      is
      it
      ja
      ka
      kk
      ko
      ku
      ky
      lt
      lv
      ms
      mt
      ne
      no
      nl
      pa
      pa-pk
      pl
      ps
      pt
      ro
      ru
      si
      sk
      sl
      so
      sq
      sr
      sv
      sw
      ta
      th
      ti
      tk
      tr
      uk
      ur
      uz
      vi
      yi
      zh
      zh-hk
      zh-tw
    ]

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation can not be found).
    config.i18n.fallbacks = true

    # Disable rack::cache
    config.action_dispatch.rack_cache = nil

    # Path within public/ where assets are compiled to
    config.assets.prefix = "/assets/government-frontend"

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    # Protect from "invalid byte sequence in UTF-8" errors,
    # when a query or a cookie is a string with incorrect UTF-8 encoding.
    config.middleware.insert_before(
      0,
      Rack::UTF8Sanitizer,
      only: %w[QUERY_STRING],
      strategy: Sanitiser::Strategy,
    )

    # Use the middleware to compact data-ga4-event/link attributes
    config.middleware.use GovukPublishingComponents::Middleware::Ga4Optimise
  end
end
