require "test_helper"

class RandomlyGeneratedContentItemControllerTest < ActionController::TestCase
  test "routing for random content item" do
    assert_routing(
      "/random/worldwide_organisation",
      controller: "randomly_generated_content_item",
      action: "show",
      schema: "worldwide_organisation",
    )
  end
end
