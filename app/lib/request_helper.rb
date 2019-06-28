module RequestHelper
  def self.get_header(header_name, request_headers)
    request_headers[headerise(header_name)]
  end

  def self.headerise(header_name)
    "HTTP_#{header_name.upcase.tr('-', '_')}"
  end
end
