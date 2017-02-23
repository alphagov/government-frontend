class EducationNavigationAbTestRequest
  NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS = %w{detailed_guide publication}.freeze

  attr_accessor :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request)
    @ab_test = GovukAbTesting::AbTest.new("EducationNavigation", dimension: 41)
    @requested_variant = @ab_test.requested_variant request
  end

  def content_schema_has_new_navigation?(content_item)
    NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS.include? content_item["schema_name"]
  end

  def should_present_new_navigation_view?(content_item)
    @requested_variant.variant_b? && new_navigation_enabled? && content_is_tagged_to_a_taxon?(content_item)
  end

  def set_response_vary_header(response)
    @requested_variant.configure_response response
  end

private

  def new_navigation_enabled?
    ENV['ENABLE_NEW_NAVIGATION'] == 'yes'
  end

  def content_is_tagged_to_a_taxon?(content_item)
    content_item.dig("links", "taxons").present?
  end
end
