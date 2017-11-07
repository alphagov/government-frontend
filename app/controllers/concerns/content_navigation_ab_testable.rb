module ContentNavigationABTestable
  CONTENT_NAVIGATION_DIMENSION = 67
  CONTENT_NAVIGATION_ORIGINAL = "Original".freeze
  CONTENT_NAVIGATION_UNIVERSAL_NO_NAVIGATION = "UniversalNoNav".freeze
  CONTENT_NAVIGATION_UNIVERSAL_MAINSTREAM_NAVIGATION = "UniversalMainstreamNav".freeze
  CONTENT_NAVIGATION_UNIVERSAL_TAXON_NAVIGATION = "UniversalTaxonNav".freeze

  CONTENT_NAVIGATION_ALLOWED_VARIANTS = [
    CONTENT_NAVIGATION_ORIGINAL,
    CONTENT_NAVIGATION_UNIVERSAL_NO_NAVIGATION,
    CONTENT_NAVIGATION_UNIVERSAL_MAINSTREAM_NAVIGATION,
    CONTENT_NAVIGATION_UNIVERSAL_TAXON_NAVIGATION
  ].freeze

  GUIDANCE_DOCUMENT_TYPES = %w(
    answer
    guide
    detailed_guide
    statutory_guidance
  ).freeze

  def self.included(base)
    base.helper_method(
      :content_navigation_variant,
      :content_navigation_ab_test_applies?,
      :content_navigation_test_original_variant?,
      :universal_navigation_without_nav?,
      :universal_navigation_with_taxon_nav?,
      :universal_navigation_with_mainstream_nav?
    )

    base.after_action :set_content_navigation_response_header
  end

  def content_navigation_ab_test
    @content_navigation_ab_test ||=
      GovukAbTesting::AbTest.new(
        "ContentNavigation",
        dimension: CONTENT_NAVIGATION_DIMENSION,
        allowed_variants: CONTENT_NAVIGATION_ALLOWED_VARIANTS
      )
  end

  # Universal navigation:
  # https://gov-uk.atlassian.net/wiki/spaces/GFED/pages/186351726/Sprint+1+designs
  #
  # Universal navigation must only be shown when:
  # * in the multivariate test
  # * not showing the original variant
  def should_present_universal_navigation?
    content_navigation_ab_test_applies? && !content_navigation_test_original_variant?
  end

  def content_navigation_ab_test_applies?
    @content_item && @content_item.tagged_to_a_taxon? && content_document_type_is_guidance?
  end

  def content_document_type_is_guidance?
    GUIDANCE_DOCUMENT_TYPES.include? @content_item.document_type
  end

  def content_navigation_test_original_variant?
    content_navigation_variant.variant?(CONTENT_NAVIGATION_ORIGINAL)
  end

  def universal_navigation_without_nav?
    content_navigation_variant.variant?(CONTENT_NAVIGATION_UNIVERSAL_NO_NAVIGATION)
  end

  def universal_navigation_with_taxon_nav?
    content_navigation_variant.variant?(CONTENT_NAVIGATION_UNIVERSAL_TAXON_NAVIGATION)
  end

  def universal_navigation_with_mainstream_nav?
    content_navigation_variant.variant?(CONTENT_NAVIGATION_UNIVERSAL_MAINSTREAM_NAVIGATION)
  end

  def content_navigation_variant
    @content_navigation_variant ||=
      content_navigation_ab_test.requested_variant(request.headers)
  end

  def set_content_navigation_response_header
    content_navigation_variant.configure_response(response) if content_navigation_ab_test_applies?
  end
end
