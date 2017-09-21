GovukNavigationHelpers.configure do |config|
  config.error_handler = GovukError
  config.statsd = Services.statsd
end
