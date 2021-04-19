module WeightedLinksAbTestable
  CUSTOM_DIMENSION = 123 # TODO: Get this value from PAs
  ALLOWED_VARIANTS = %w[A B Z].freeze

  def weighted_links_test
    @weighted_links_test ||= GovukAbTesting::AbTest.new(
      "WeightedLinksAbTestable",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def weighted_links_variant
    weighted_links_test.requested_variant(request.headers)
  end

  def set_weighted_links_response
    weighted_links_variant.configure_response(response) if weighted_links_testable?
  end

  def weighted_links_testable?
    WeightedLinksPage.find_page_with_base_path(request.path)
  end
end
