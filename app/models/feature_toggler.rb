class FeatureToggler
  attr_reader :feature_flags

  def initialize(feature_flags)
    @feature_flags = feature_flags
  end

  def use_recommended_related_links?(content_item_links, request_headers)
    return false if content_item_links.nil?

    content_item_links.fetch('ordered_related_items', []).empty? &&
      content_item_links.fetch('ordered_related_items_overrides', []).empty? &&
      @feature_flags.feature_enabled?(FeatureFlagNames.recommended_related_links, request_headers)
  end
end
