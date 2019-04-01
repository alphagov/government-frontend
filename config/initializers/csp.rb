module CSP
  # Generate a Content Security Policy (CSP) directive.
  #
  # This code should eventually be moved to https://github.com/alphagov/govuk_app_config
  #
  #
  # Extracted in a separate module to allow comments.
  #
  # See https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP for more CSP info.
  #
  # The resulting policy should be checked with:
  #
  # - https://csp-evaluator.withgoogle.com
  # - https://cspvalidator.org

  GOVUK_DOMAINS = "'self' *.publishing.service.gov.uk localhost".freeze

  GOOGLE_ANALYTICS_DOMAINS = "www.google-analytics.com ssl.google-analytics.com".freeze

  def self.build
    policies = []

    # By default, only allow HTTPS connections, and allow loading things from
    # the publishing domain
    #
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/default-src
    policies << [
      "default-src https",
      GOVUK_DOMAINS
    ]

    # Allow images from the current domain, Google Analytics (the tracking pixel),
    # and publishing domains.
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/img-src
    policies << [
      "img-src",

      # Allow `data:` images for Base64-encoded images in CSS like:
      #
      # https://github.com/alphagov/service-manual-frontend/blob/1db99ed48de0dfc794b9686a98e6c62f8435ae80/app/assets/stylesheets/modules/_search.scss#L106
      "data:",

      GOVUK_DOMAINS,
      GOOGLE_ANALYTICS_DOMAINS,

      # Some content still links to an old domain we used to use
      "assets.digital.cabinet-office.gov.uk",
    ]

    # script-src determines the scripts that the browser can load
    #
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/script-src
    policies << [
      # Allow scripts from publishing domains
      "script-src",
      GOVUK_DOMAINS,
      GOOGLE_ANALYTICS_DOMAINS,

      # Allow JSONP call to Verify to check whether the user is logged in
      # https://www.staging.publishing.service.gov.uk/log-in-file-self-assessment-tax-return/sign-in/prove-identity
      # https://github.com/alphagov/government-frontend/blob/71aca4df9b74366618a5a93acdb5cd2715f94f49/app/assets/javascripts/modules/track-radio-group.js
      "www.signin.service.gov.uk",

      # Allow YouTube Embeds (Govspeak turns YouTube links into embeds)
      "*.ytimg.com",
      "www.youtube.com",

      # Allow all inline scripts until we can conclusively document all the inline scripts we use,
      # and there's a better way to filter out junk reports
      "'unsafe-inline'"
    ]

    # Allow styles from own domain and publishing domains.
    #
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/style-src
    policies << [
      "style-src",
      GOVUK_DOMAINS,

      # Also allow "unsafe-inline" styles, because we use the `style=""` attribute on some HTML elements
      "'unsafe-inline'"
    ]

    # Allow fonts to be loaded from data-uri's (this is the old way of doing things)
    # or from the publishing asset domains.
    #
    # https://www.staging.publishing.service.gov.uk/apply-for-a-licence/test-licence/westminster/apply-1
    #
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/font-src
    policies << [
      "font-src data:",
      GOVUK_DOMAINS
    ]

    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/connect-src
    policies << [
      # Scripts can only load data using Ajax from Google Analytics and the publishing domains
      "connect-src",
      GOVUK_DOMAINS,
      GOOGLE_ANALYTICS_DOMAINS,

      # Allow connecting to web chat from HMRC contact pages like
      # https://www.staging.publishing.service.gov.uk/government/organisations/hm-revenue-customs/contact/child-benefit
      "www.tax.service.gov.uk",

      # Allow connecting to Verify to check whether the user is logged in
      # https://github.com/alphagov/government-frontend/blob/71aca4df9b74366618a5a93acdb5cd2715f94f49/app/assets/javascripts/modules/track-radio-group.js
      # https://www.staging.publishing.service.gov.uk/log-in-file-self-assessment-tax-return/sign-in/prove-identity
      "www.signin.service.gov.uk",
    ]

    # Disallow all <object>, <embed>, and <applet> elements
    #
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/object-src
    policies << [
      "object-src 'none'"
    ]

    policies << [
      "frame-src",

      # Allow YouTube embeds
      "www.youtube.com",
    ]

    policies.map { |str| str.join(" ") }.join("; ") + ";"
  end
end

# In test and development, use CSP for real to find issues. In production we only
# report violations to Sentry (https://sentry.io/govuk/govuk-frontend-csp) via an
# AWS Lambda function that filters out junk reports.
if Rails.env.production?
  reporting = "report-uri https://jhpno0hk6b.execute-api.eu-west-2.amazonaws.com/production"
  Rails.application.config.action_dispatch.default_headers['Content-Security-Policy-Report-Only'] = CSP.build + " " + reporting
else
  Rails.application.config.action_dispatch.default_headers['Content-Security-Policy'] = CSP.build
end
