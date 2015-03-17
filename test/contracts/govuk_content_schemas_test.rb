require 'test_helper'

class GovukContentSchemasTest < ActionDispatch::IntegrationTest
  include GovukContentSchemaExamples

  all_examples_for_supported_formats.each do |content_item|
    test "can successfully render #{content_item['base_path']} schema example" do
      content_store_has_item(content_item['base_path'], content_item)

      get content_item['base_path'].sub(/^\//, '')

      assert_response :success
    end
  end
end
