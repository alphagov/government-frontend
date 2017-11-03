class EducationNavigationAbTestRequest
  NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS =
    %w{answer contact guide detailed_guide document_collection publication}.freeze

  attr_accessor :requested_variant

  delegate :analytics_meta_tag, to: :requested_variant

  def initialize(request, content_item)
    @content_item = content_item
    @ab_test = GovukAbTesting::AbTest.new("EducationNavigation", dimension: 41)
    @requested_variant = @ab_test.requested_variant(request.headers)
  end

  def ab_test_applies?
    false
  end

  def should_present_new_navigation_view?
    ab_test_applies? && @requested_variant.variant?("B")
  end

  def set_response_vary_header(response)
    @requested_variant.configure_response response
  end

private

  def content_is_tagged_to_a_taxon?
    @content_item.dig("links", "taxons").present?
  end

  def content_schema_has_new_navigation?
    NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS.include? @content_item["schema_name"]
  end
end
