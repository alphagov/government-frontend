if ENV["GOVUK_RAILS_JSON_LOGGING"]
  GovukJsonLogging.configure do
    add_custom_fields do |fields|
      fields[:header_keys] = request.headers.keys.join(",")
      fields[:x_forwarded_for] = request.headers["X-Forwarded-For"]
    end
  end
end
