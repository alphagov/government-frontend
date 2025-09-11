require "test_helper"

class RandomlyGeneratedContentItemControllerTest < ActionController::TestCase
  test "routing for random content item" do
    assert_routing(
      "/random/case_study",
      controller: "randomly_generated_content_item",
      action: "show",
      schema: "case_study",
    )
  end
end
