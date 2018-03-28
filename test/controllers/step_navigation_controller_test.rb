require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  %w(guide answer publication).each do |schema_name|
    test "#{schema_name} shows step by step navigation where relevant" do
      content_item = content_store_has_schema_example(schema_name, "#{schema_name}-with-step-navs")
      content_item['base_path'] = "/pass-plus"
      path = content_item['base_path'][1..-1]

      content_store_has_item(content_item['base_path'], content_item)

      get :show, params: { path: path }

      assert_response 200
      assert response.body.include?("Learn to drive a car: step by step")
    end

    test "#{schema_name} does not show step by step navigation where relevant" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      content_item['base_path'] = "/not-part-of-a-step-by-step"
      path = content_item['base_path'][1..-1]

      content_store_has_item(content_item['base_path'], content_item)

      get :show, params: { path: path }

      assert_response 200
      refute response.body.include?("Learn to drive a car: step by step")
    end
  end
end
