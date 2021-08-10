require "test_helper"

class ContentItemsControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  test "shows new header for variant B" do
    for_each_schema do |schema|
      with_variant ExploreMenuAbTestable: "B" do
        set_up_and_visit_content_item_for_schema(schema)

        assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "B", 47)
      end
    end
  end

  test "doesn't show new header for variant A" do
    for_each_schema do |schema|
      with_variant ExploreMenuAbTestable: "A" do
        set_up_and_visit_content_item_for_schema(schema)

        assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "A", 47)
      end
    end
  end

  test "doesn't show new header for variant Z" do
    for_each_schema do |schema|
      with_variant ExploreMenuAbTestable: "Z" do
        set_up_and_visit_content_item_for_schema(schema)

        assert_page_tracked_in_ab_test("ExploreMenuAbTestable", "Z", 47)
      end
    end
  end

private

  def set_up_and_visit_content_item_for_schema(schema)
    content_item = content_store_has_schema_example(schema, schema)
    stub_content_store_has_item(content_item["base_path"], content_item)
    path = content_item["base_path"][1..]

    get :show, params: { path: path }
  end

  def for_each_schema(&block)
    %w[guide answer document_collection].each(&block)
  end
end
