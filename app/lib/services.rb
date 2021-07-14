require "gds_api/content_store"
require "gds_api/publishing_api"

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(
      Plek.current.find("content-store"),
      # Disable caching to avoid caching a stale max-age in the cache control
      # headers, which would cause this app to set the wrong max-age on its
      # own responses
      disable_cache: true,
    )
  end

  def self.feature_toggler
    @feature_toggler ||= FeatureToggler.new(
      HttpFeatureFlags.instance,
    )
  end

  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(
      Plek.find("publishing-api"),
      bearer_token: ENV.fetch("PUBLISHING_API_BEARER_TOKEN", "example"),
    )
  end

  def self.search_api
    @search_api = GdsApi::Search.new(
      Plek.find("search"),
      bearer_token: ENV.fetch("RUMMAGER_BEARER_TOKEN", "example"),
    )
  end
end
