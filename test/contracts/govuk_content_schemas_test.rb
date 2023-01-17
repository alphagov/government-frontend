require "test_helper"

class GovukContentSchemasTest < ActionDispatch::IntegrationTest
  include GovukContentSchemaExamples

  all_examples_for_supported_schemas.each_with_index do |content_item, index|
    test "can successfully render #{content_item['document_type']} #{index} example" do
      stub_content_store_has_item(content_item["base_path"], content_item)
      stub_parent_breadcrumbs(content_item, content_item["document_type"])

      get content_item["base_path"]

      assert_response :success
    end
  end
end
