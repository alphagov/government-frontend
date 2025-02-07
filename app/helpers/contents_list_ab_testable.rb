module ContentsListAbTestable
  ALLOWED_VARIANTS = %w[A B Z].freeze

  AB_TEST_PAGES = [
    # Help paying for childcare
    "/help-with-childcare-costs",
    "/help-with-childcare-costs/free-childcare-and-education-for-3-to-4-year-olds",
    "/help-with-childcare-costs/free-childcare-2-year-olds-claim-benefits",
    "/help-with-childcare-costs/tax-credits",
    "/help-with-childcare-costs/universal-credit",
    "/help-with-childcare-costs/childcare-vouchers",
    "/help-with-childcare-costs/support-while-you-study",
    # What to do after someone dies
    "/after-a-death",
    "/after-a-death/when-a-death-is-reported-to-a-coroner",
    "/after-a-death/death-abroad",
    "/after-a-death/organisations-you-need-to-contact-and-tell-us-once",
    "/after-a-death/report-without-tell-us-once",
    "/after-a-death/arrange-the-funeral",
    "/after-a-death/if-a-child-or-baby-dies",
    "/after-a-death/bereavement-help-and-support",
    # Become a sole trader
    "/become-sole-trader",
    "/become-sole-trader/choose-your-business-name",
    "/become-sole-trader/register-sole-trader",
    # Set up a private limited company
    "/limited-company-formation",
    "/limited-company-formation/choose-company-name",
    "/limited-company-formation/company-address",
    "/limited-company-formation/appoint-directors-and-company-secretaries",
    "/limited-company-formation/shareholders",
    "/limited-company-formation/memorandum-and-articles-of-association",
    "/limited-company-formation/register-your-company",
    "/limited-company-formation/add-corporation-tax-services-to-business-tax-account",
  ].freeze

  def contents_list_test
    @contents_list_test ||= GovukAbTesting::AbTest.new(
      "ContentsList",
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def contents_list_variant
    contents_list_test.requested_variant(request.headers)
  end

  def set_contents_list_response_header
    contents_list_variant.configure_response(response)
  end

  def show_contents_list_ab_test?
    var_b = contents_list_variant.variant?("B")
    step_by_step_page_under_test? && var_b
  end

  def step_by_step_page_under_test?
    AB_TEST_PAGES.include? request.path
  end
end
