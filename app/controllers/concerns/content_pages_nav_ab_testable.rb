module ContentPagesNavAbTestable
  CUSTOM_DIMENSION = 65

  def self.included(base)
    base.helper_method(
      :content_pages_nav_test_variant,
      :show_new_navigation?,
      :page_in_scope?,
      :should_show_sidebar?
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
    content_pages_nav_test_variant.variant?("B") && page_in_scope?
  end

  def page_in_scope?
    # Pages are in scope if:
    # - They are not an out-of-scope format, e.g: html publications
    # - They are tagged to the taxonomy
    if @content_item
      not_an_html_publication? && has_a_live_taxon?
    end
  end

  def not_an_html_publication?
    !@content_item.document_type.eql?("html_publication")
  end

  def has_a_live_taxon?
    @content_item.taxons.present? &&
      @content_item.taxons.detect { |taxon| taxon["phase"] == "live" }
  end

  def should_show_sidebar?
    content_pages_nav_test_variant.variant?("A") || @content_item.content_item.parsed_content['publishing_app'] != "whitehall"
  end
end
