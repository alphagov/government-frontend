module ContextualCommsAbTestable
  GOOGLE_ANALYTICS_CUSTOM_DIMENSION = 70
  CAMPAIGN_DATA = {
    get_in_go_far: {
      title: "Get In Go Far",
      description: "Search thousands of apprenticeships from great companies, with more added every day.",
      link: "https://www.getingofar.gov.uk/",
    },
    eating: {
      title: "How healthy is your food?",
      description: "Find out more about calories, the benefits of eating well and simple ways you can make a change.",
      link: "https://www.nhs.uk/oneyou/eating",
    }
  }.freeze

  def self.included(base)
    base.helper_method(
      :campaign_description,
      :campaign_link,
      :campaign_title,
      :contextual_comms_test_variant,
      :show_blue_box_campaign?,
      :show_contextual_comms_campaign?,
      :show_native_campaign?,
      :whitelisted_campaign_page?,
    )
    base.after_action :set_test_response_header
  end

  def contextual_comms_test
    @contextual_comms_test ||= GovukAbTesting::AbTest.new(
      "ContextualComms",
      dimension: GOOGLE_ANALYTICS_CUSTOM_DIMENSION,
      allowed_variants: %w(NoCampaign BlueBoxCampaign NativeCampaign),
      control_variant: "NoCampaign"
    )
  end

  def contextual_comms_test_variant
    @contextual_comms_test_variant ||= contextual_comms_test.requested_variant(request.headers)
  end

  def set_test_response_header
    contextual_comms_test_variant.configure_response(response) if whitelisted_campaign_page?
  end

  def show_contextual_comms_campaign?
    !contextual_comms_test_variant.variant?("NoCampaign") && whitelisted_campaign_page?
  end

  def show_blue_box_campaign?
    contextual_comms_test_variant.variant?("BlueBoxCampaign")
  end

  def show_native_campaign?
    contextual_comms_test_variant.variant?("NativeCampaign")
  end

  def whitelisted_campaign_page?
    campaign_name.present?
  end

  def campaign_name
    @campaign_name ||=
      if GET_IN_GO_FAR_PAGES.include?(content_item_path)
        :get_in_go_far
      elsif EATING_PAGES.include?(content_item_path)
        :eating
      end
  end

  def campaign_link
    CAMPAIGN_DATA[campaign_name][:link]
  end

  def campaign_title
    CAMPAIGN_DATA[campaign_name][:title]
  end

  def campaign_description
    CAMPAIGN_DATA[campaign_name][:description]
  end

  GET_IN_GO_FAR_PAGES = %w(
    /career-skills-and-training
    /mature-student-university-funding
    /higher-education-courses-find-and-apply
    /what-different-qualification-levels-mean
    /what-different-qualification-levels-mean/list-of-qualification-levels
    /what-different-qualification-levels-mean/compare-different-qualification-levels
    /further-education-courses
    /improve-english-maths-it-skills
    /further-education-courses
    /further-education-courses/financial-help
    /further-education-courses/find-a-course
    /looking-for-work-if-disabled
    /exoffenders-and-employment
  ).freeze

  EATING_PAGES = %w(
    /free-school-transport
    /healthy-start
    /healthy-start/eligibility
    /healthy-start/how-to-claim
    /healthy-start/what-youll-get
    /help-with-childcare-costs
    /help-with-childcare-costs/childcare-vouchers
    /help-with-childcare-costs/free-childcare-2-year-olds
    /help-with-childcare-costs/free-childcare-2-year-olds-benefits
    /help-with-childcare-costs/free-childcare-and-education-for-2-to-4-year-olds
    /help-with-childcare-costs/support-while-you-study
    /help-with-childcare-costs/tax-credits
    /help-with-childcare-costs/tax-free-childcare
    /help-with-childcare-costs/universal-credit
    /school-uniform
  ).freeze
end
