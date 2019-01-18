module AATestable
  RELATED_LINKS_DIMENSION = 65

  def self.included(base)
    base.helper_method(
      :related_links_variant
    )
    base.after_action :set_test_response_header
  end

  def related_links_variant
    @related_links_variant ||= related_links_test.requested_variant(request.headers)
  end

private

  def related_links_test
    @related_links_test ||= GovukAbTesting::AbTest.new(
      "RelatedLinksAATest",
      dimension: RELATED_LINKS_DIMENSION,
      allowed_variants: %w(A B),
      control_variant: "A"
    )
  end

  def set_test_response_header
    related_links_variant.configure_response(response)
  end
end
