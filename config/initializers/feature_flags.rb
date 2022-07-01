module FeatureFlagNames
  def self.recommended_related_links
    "Govuk-Use-Recommended-Related-Links"
  end
end

Rails.application.reloader.to_prepare do
  # Autoload classes and modules needed at boot time here.
  HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
end
