# GovukContentSecurityPolicy.configure
# THIS A TEMPORARY COPY OF THE POLICY FROM THE GEM ABOVE
# FOR THE TEMPORARY TEST WE NEED TO ADD A NEW DOMAIN FOR IMAGES (LINE 30)
# WILL BE REVERTED BACK TO THE GEM ONCE THE TESTS FINISHES

GOVUK_DOMAINS = [
    '*.publishing.service.gov.uk',
    "*.#{ENV['GOVUK_APP_DOMAIN_EXTERNAL'] || ENV['GOVUK_APP_DOMAIN'] || 'dev.gov.uk'}",
    "*.dev.gov.uk"
  ].uniq.freeze

GOOGLE_ANALYTICS_DOMAINS = %w(www.google-analytics.com
                              ssl.google-analytics.com
                              stats.g.doubleclick.net).freeze

Rails.application.config.content_security_policy_report_only = ENV.include?("GOVUK_CSP_REPORT_ONLY")

Rails.application.config.content_security_policy do |policy|
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/default-src
  policy.default_src :https, :self, *GOVUK_DOMAINS

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/img-src
  policy.img_src :self,
                :data, # Base64 encoded images
                *GOVUK_DOMAINS,
                *GOOGLE_ANALYTICS_DOMAINS, # Tracking pixels
                # Some content still links to an old domain we used to use
                "assets.digital.cabinet-office.gov.uk",
                # For a Verify enhanced hint live test (temporary)
                "gds-verify-frontend-assets.s3.amazonaws.com"

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/script-src
  policy.script_src :self,
                    *GOVUK_DOMAINS,
                    *GOOGLE_ANALYTICS_DOMAINS,
                    # Allow JSONP call to Verify to check whether the user is logged in
                    "www.signin.service.gov.uk",
                    # Allow YouTube Embeds (Govspeak turns YouTube links into embeds)
                    "*.ytimg.com",
                    "www.youtube.com",
                    "www.youtube-nocookie.com",
                    # Allow all inline scripts until we can conclusively
                    # document all the inline scripts we use,
                    # and there's a better way to filter out junk reports
                    :unsafe_inline

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/style-src
  policy.style_src :self,
                  *GOVUK_DOMAINS,
                  # We use the `style=""` attribute on some HTML elements
                  :unsafe_inline

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/font-src
  policy.font_src :self,
                  *GOVUK_DOMAINS,
                  :data # Used by some legacy fonts

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/connect-src
  policy.connect_src :self,
                    *GOVUK_DOMAINS,
                    *GOOGLE_ANALYTICS_DOMAINS,
                    # Allow connecting to web chat from HMRC contact pages
                    "www.tax.service.gov.uk",
                    # Allow connecting to Verify to check whether the user is logged in
                    "www.signin.service.gov.uk"

  # Disallow all <object>, <embed>, and <applet> elements
  #
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/object-src
  policy.object_src :none

  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/frame-src
  policy.frame_src :self, *GOVUK_DOMAINS, "www.youtube.com", "www.youtube-nocookie.com" # Allow youtube embeds

  policy.report_uri ENV["GOVUK_CSP_REPORT_URI"] if ENV.include?("GOVUK_CSP_REPORT_URI")
end