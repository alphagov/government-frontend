require "test_helper"

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  test "ContextualComms shows no campaigns for variant 'NoCampaign'" do
    content_store_has_item(content_item["base_path"], content_item)

    with_variant ContextualComms: "NoCampaign" do
      get :show, params: { path: path_for(content_item) }
      assert_response 200

      refute_match("native-campaign", response.body)
      refute_match("blue-box-campaign", response.body)
    end
  end

  test "ContextualComms shows a blue box campaign for variant 'BlueBoxCampaign'" do
    content_store_has_item(content_item["base_path"], content_item)

    with_variant ContextualComms: "BlueBoxCampaign" do
      get :show, params: { path: path_for(content_item) }
      assert_response 200

      assert_match("blue-box-campaign", response.body)
      assert_match("Get In Go Far", response.body)
      assert_match("Search thousands of apprenticeships from great companies, with more added every day.", response.body)
      assert_match("<a href=\"https://www.getingofar.gov.uk/\">", response.body)
    end
  end

  test "ContextualComms shows a native campaign for variant 'NativeCampaign'" do
    content_store_has_item(content_item["base_path"], content_item)

    with_variant ContextualComms: "NativeCampaign" do
      get :show, params: { path: path_for(content_item) }
      assert_response 200

      assert_match("native-campaign", response.body)
      assert_match("How healthy is your food?", response.body)
      assert_match("Find out more about calories, the benefits of eating well and simple ways you can make a change.", response.body)
      assert_match("<a href=\"https://www.nhs.uk/oneyou/eating\">", response.body)
    end
  end

  def content_item
    content_item = content_store_has_schema_example("answer", "answer")
    content_item["base_path"] = "/career-skills-and-training"
    content_item
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
