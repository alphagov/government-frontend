require 'gds_api/content_store'
require 'statsd'

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.current.find("content-store"))
  end

  def self.statsd
    @statsd ||= begin
      statsd_client = Statsd.new("localhost")
      statsd_client.namespace = ENV['GOVUK_STATSD_PREFIX'].to_s
      statsd_client
    end
  end
end
