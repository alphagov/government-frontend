require 'test_helper'

class GovukContentSchemasTest < ActionDispatch::IntegrationTest
  include GovukContentSchemaExamples

  govuk_content_schema_examples.each do |example_name, content_item|
    test "can successfully render #{example_name} schema example" do
      get content_item['base_path'].sub(/^\//, '')

      assert_response :success
    end
  end
end
