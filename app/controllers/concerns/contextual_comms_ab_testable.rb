module ContextualCommsAbTestable
  GOOGLE_ANALYTICS_CUSTOM_DIMENSION = 70
  CAMPAIGN_DATA = {
    get_in_go_far: {
      title: "Get In Go Far",
      description: "Search thousands of apprenticeships from great companies, with more added every day.",
      link: "https://www.getingofar.gov.uk/",
    },
  }.freeze

  def self.included(base)
    base.helper_method(
      :campaign_description,
      :campaign_link,
      :campaign_title,
      :contextual_comms_test_variant,
      :show_blue_box_campaign?,
      :show_native_campaign?,
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
    contextual_comms_test_variant.configure_response(response)
  end

  def show_blue_box_campaign?
    contextual_comms_test_variant.variant?("BlueBoxCampaign")
  end

  def show_native_campaign?
    contextual_comms_test_variant.variant?("NativeCampaign")
  end

  def campaign_name
    @campaign_name ||=
      if GET_IN_GO_FAR_PAGES.include?(content_item_path)
        :get_in_go_far
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
end
