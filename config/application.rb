require_relative 'boot'

# Pick the frameworks you want:
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GovernmentFrontend
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Explicitly set available locales
    config.i18n.available_locales = [
      :en, :ar, :az, :be, :bg, :bn, :cs, :cy, :de, :dr, :el,
      :es, 'es-419', :et, :fa, :fr, :he, :hi, :hu, :hy, :id,
      :it, :ja, :ka, :ko, :lt, :lv, :ms, :pl, :ps, :pt, :ro,
      :ru, :si, :sk, :so, :sq, :sr, :sw, :ta, :th, :tk, :tr,
      :uk, :ur, :uz, :vi, :zh, 'zh-hk', 'zh-tw'
    ]

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation can not be found).
    config.i18n.fallbacks = true

    # Disable rack::cache
    config.action_dispatch.rack_cache = nil

    # Path within public/ where assets are compiled to
    config.assets.prefix = '/government-frontend'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true
  end
end
