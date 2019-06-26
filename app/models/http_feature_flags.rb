class HttpFeatureFlags
  def initialize
    @feature_flags = {}
  end

  def add_http_feature_flag(header_name, val)
    @feature_flags[header_name] = val
  end

  def feature_enabled?(header_name, request_headers)
    @feature_flags.has_key?(header_name) && @feature_flags[header_name] == request_headers[header_name]
  end

  def self.instance
    @instance ||= HttpFeatureFlags.new
  end
end
