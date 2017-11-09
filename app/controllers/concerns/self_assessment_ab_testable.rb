module SelfAssessmentABTestable
  SELF_ASSESSMENT_AB_PAGES = %w(
    /log-in-file-self-assessment-tax-return
    /log-in-file-self-assessment-tax-return/choose-sign-in
    /log-in-file-self-assessment-tax-return/not-registered
    /log-in-file-self-assessment-tax-return/lost-account-details
  ).freeze

  def self.included(base)
    base.helper_method(
      :self_assessment_start_page?
    )
  end

  def set_up_self_assessment_ab_test
    ab_test = GovukAbTesting::AbTest.new("SelfAssessmentSigninTest", dimension: 65)

    @self_assessment_requested_variant = ab_test.requested_variant(request.headers)
    @self_assessment_requested_variant.configure_response(response)
  end

  def set_up_self_assessment_ab_content_item
    set_up_self_assessment_ab_test
    content_item = Services.content_store.content_item(content_item_path)
    ContentItemPresenter.new(content_item, content_item_path)
  end

  def self_assessment_start_page?(content_item)
    SELF_ASSESSMENT_AB_PAGES.include?(content_item["base_path"])
  end

  def replace_self_assessment_part_one(content_item)
    if self_assessment_start_page?(content_item) && @self_assessment_requested_variant.variant?('B')
      @b_variant_content ||= File.read(Rails.root.join("app", "assets", "html", "self_assessment_b_variant.html"))
      content_item["details"]["parts"].first["body"] = @b_variant_content.to_s
    end
    content_item
  end
end
