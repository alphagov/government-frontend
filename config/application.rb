require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
# require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
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
    # config.time_zone = 'Central Time (US & Canada)'

    # Explicitly set default locale
    config.i18n.default_locale = :en

    # Explicitly set available locales
    config.i18n.available_locales = [
      :en, :ar, :az, :be, :bg, :bn, :cs, :cy, :de, :dr, :el,
      :es, 'es-419', :et, :fa, :fr, :he, :hi, :hu, :hy, :id,
      :it, :ja, :ka, :ko, :lt, :lv, :ms, :pl, :ps, :pt, :ro,
      :ru, :si, :sk, :so, :sq, :sr, :sw, :ta, :th, :tk, :tr,
      :uk, :ur, :uz, :vi, :zh, 'zh-hk', 'zh-tw']

    # Disable rack::cache
    config.action_dispatch.rack_cache = nil

    # Caching
    config.cache_control_directive = 'public'

    # Path within public/ where assets are compiled to
    config.assets.prefix = '/government-frontend'
  end
end
