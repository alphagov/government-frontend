module CookielessTestable
  extend ActiveSupport::Concern

  CUSTOM_DIMENSION = 49

  def self.included(base)
    base.helper_method(
      :cookieless_variant,
    )
    base.after_action :set_test_response_header
  end

  def cookieless_variant
    @cookieless_variant ||= cookieless_test.requested_variant(request.headers)
  end

private

  def cookieless_test
    @cookieless_test ||= GovukAbTesting::AbTest.new(
      "CookielessAATest",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: %w[A B Z],
      control_variant: "Z",
    )
  end

  def set_test_response_header
    cookieless_variant.configure_response(response)
  end
end
