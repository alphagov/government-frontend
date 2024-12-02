class Features
  def self.graphql_feature_enabled?
    ENV["GRAPHQL_FEATURE_FLAG"]
  end
end
