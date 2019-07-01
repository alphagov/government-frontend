class HttpFeatureFlags
  def initialize
    @feature_flags = {}
  end

  def add_http_feature_flag(feature_flag_name, val)
    @feature_flags[RequestHelper.headerise(feature_flag_name)] = val
  end

  def get_feature_flag(feature_flag_name)
    @feature_flags[RequestHelper.headerise(feature_flag_name)]
  end

  def feature_enabled?(feature_flag_name, request_headers)
    get_feature_flag(feature_flag_name) == RequestHelper.get_header(feature_flag_name, request_headers)
  end

  def self.instance
    @instance ||= HttpFeatureFlags.new
  end
end
