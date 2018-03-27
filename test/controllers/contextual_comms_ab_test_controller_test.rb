require "test_helper"

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  # govuk_base_path is an example page that is eligible to show a campaign.
  CAMPAIGNS = {
    get_in_go_far: {
      govuk_base_path: "/career-skills-and-training",
      title: "Get In Go Far",
      description: "Search thousands of apprenticeships from great companies, with more added every day.",
      href: "<a href=\"https://www.getingofar.gov.uk/\">",
    },
    eating: {
      govuk_base_path: "/free-school-transport",
      title: "How healthy is your food?",
      description: "Find out more about calories, the benefits of eating well and simple ways you can make a change.",
      href: "<a href=\"https://www.nhs.uk/oneyou/eating\">",
    },
    check_your_pay: {
      govuk_base_path: "/pay-and-work-rights",
      title: "Check Your Pay",
      description: "Are you being underpaid? Find out if your employer is giving you less than the legal minimum.",
      href: "<a href=\"https://checkyourpay.campaign.gov.uk\">",
    },
    your_pension: {
      govuk_base_path: "/armed-forces-pension-calculator",
      title: "Get to know your state pension",
      description: "Get an online forecast to tell you how much you might get, and the earliest you can claim it.",
      href: "<a href=\"https://www.yourpension.gov.uk/\">"
    }
  }.freeze

  test "ContextualComms shows no campaigns for variant 'NoCampaign'" do
    CAMPAIGNS.each_value do |value|
      content_item = set_content_item(value[:govuk_base_path])
      content_store_has_item(value[:govuk_base_path], content_item)

      with_variant ContextualComms: "NoCampaign" do
        get :show, params: { path: path_for(content_item) }
        assert_response 200

        refute_match("native-campaign", response.body)
        refute_match("blue-box-campaign", response.body)
      end
    end
  end

  test "ContextualComms shows a blue box campaign for variant 'BlueBoxCampaign'" do
    CAMPAIGNS.each do |key, value|
      # as the campaign_name method is memoized, we need to ensure the correct campaign name is returned for each test
      @controller.stubs(:campaign_name).returns(key)
      content_item = set_content_item(value[:govuk_base_path])
      content_store_has_item(value[:govuk_base_path], content_item)

      with_variant ContextualComms: "BlueBoxCampaign" do
        get :show, params: { path: path_for(content_item) }
        assert_response 200

        assert_match("blue-box-campaign", response.body)
        assert_match(value[:title], response.body)
        assert_match(value[:description], response.body)
        assert_match(value[:href], response.body)
      end
    end
  end

  test "ContextualComms shows a native campaign for variant 'NativeCampaign'" do
    CAMPAIGNS.each do |key, value|
      # as the campaign_name method is memoized, we need to ensure the correct campaign name is returned for each test
      @controller.stubs(:campaign_name).returns(key)
      content_item = set_content_item(value[:govuk_base_path])
      content_store_has_item(value[:govuk_base_path], content_item)

      with_variant ContextualComms: "NativeCampaign" do
        get :show, params: { path: path_for(content_item) }
        assert_response 200

        assert_match("native-campaign", response.body)
        assert_match(value[:title], response.body)
        assert_match(value[:description], response.body)
        assert_match(value[:href], response.body)
      end
    end
  end

  test "No campaign is shown on pages that haven't been whitelisted" do
    content_item = set_content_item("/an-answer")
    content_store_has_item(content_item["base_path"], content_item)

    get :show, params: { path: path_for(content_item) }
    assert_response 200

    refute_match("native-campaign", response.body)
    refute_match("blue-box-campaign", response.body)
  end

  def set_content_item(base_path)
    content_item = content_store_has_schema_example("answer", "answer")
    content_item["base_path"] = base_path
    content_item
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
