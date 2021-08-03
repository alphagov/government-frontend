module AbTests::SabPagesTestable
  CUSTOM_DIMENSION = 48

  def self.included(base)
    base.helper_method(
      :sab_page_variant,
      :is_testable_sab_page?,
      :should_show_sab_intervention?,
    )
    base.after_action :set_test_response_header
  end

  def sab_page_variant
    @sab_page_variant ||= sab_page_test.requested_variant(request.headers)
  end

  def is_testable_sab_page?
    @is_testable_sab_page ||= request.headers["HTTP_GOVUK_ABTEST_ISSTARTABUSINESSPAGE"] == "true"
  end

  def should_show_sab_intervention?
    sab_page_variant.variant?("B") && is_testable_sab_page?
  end

private

  def sab_page_test
    @sab_page_test ||= GovukAbTesting::AbTest.new(
      "StartABusinessSegment",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: %w[A B C],
      control_variant: "A",
    )
  end

  def set_test_response_header
    if is_testable_sab_page?
      sab_page_variant.configure_response(response)
    end
  end
end
