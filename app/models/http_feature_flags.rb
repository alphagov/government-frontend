class HttpFeatureFlags
  def initialize
    @feature_flags = {}
  end

  def add_http_feature_flag(feature_flag_name, val)
    @feature_flags[get_header_name(feature_flag_name)] = val
  end

  def get_feature_flag(feature_flag_name)
    @feature_flags[get_header_name(feature_flag_name)]
  end

  def feature_enabled?(feature_flag_name, request_headers)
    get_feature_flag(feature_flag_name) == request_headers[get_header_name(feature_flag_name)]
  end

  def self.instance
    @instance ||= HttpFeatureFlags.new
  end

private

  def get_header_name(feature_flag_name)
    "HTTP_#{feature_flag_name.upcase.tr('-', '_')}"
  end
end
