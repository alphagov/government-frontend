require 'statsd'

module Services
  def self.statsd
    @statsd ||= begin
      statsd_client = Statsd.new("localhost")
      statsd_client.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      statsd_client
    end
  end
end
