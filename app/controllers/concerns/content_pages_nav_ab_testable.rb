module ContentPagesNavAbTestable
  CUSTOM_DIMENSION = 65

  def self.included(base)
    base.helper_method(
      :content_pages_nav_test_variant,
      :show_new_navigation?,
      :page_in_scope?
    )
    base.after_action :set_test_response_header
  end

  def content_pages_nav_test
    @content_pages_nav_test ||= GovukAbTesting::AbTest.new(
      "ContentPagesNav",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: %w(A B),
      control_variant: "A"
    )
  end

  def content_pages_nav_test_variant
    @content_pages_nav_test_variant ||= content_pages_nav_test.requested_variant(request.headers)
  end

  def set_test_response_header
    content_pages_nav_test_variant.configure_response(response) if page_in_scope?
  end

  def show_new_navigation?
    !content_pages_nav_test_variant.variant?("B") && page_in_scope?
  end

  def page_in_scope?
    #TODO Page is tagged to a taxon
    false
  end
end
