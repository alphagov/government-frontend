require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  %w(guide answer publication).each do |schema_name|
    test "#{schema_name} honours Tasklist Header AB Testing cookie" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      content_item['base_path'] = "/pass-plus"
      path = content_item['base_path'][1..-1]

      content_store_has_item(content_item['base_path'], content_item)

      ab_test = GovukAbTesting::AbTest.new("TaskListHeader", dimension: 44)

      with_variant TaskListHeader: "A" do
        get :show, params: { path: path }
        requested = ab_test.requested_variant(request.headers)
        assert_response 200
        assert requested.variant?('A')

        refute response.body.include?("Learn to drive a car: step by step")
      end

      with_variant TaskListHeader: "B" do
        get :show, params: { path: path }

        requested = ab_test.requested_variant(request.headers)
        assert_response 200
        assert requested.variant?('B')

        assert response.body.include?("Learn to drive a car: step by step")
      end
    end
  end
end
