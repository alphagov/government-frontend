module FeatureFlagNames
  def self.recommended_related_links
    'HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS'
  end
end

HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, 'true')
