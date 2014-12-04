require 'test_helper'
require 'gds_api/test_helpers/content_store'

# TODO: Tidy up. This is to skip slimmer
class ActionController::Base
  before_filter proc {
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  }
end

class GovukContentSchemasTest < ActionDispatch::IntegrationTest
  include GovukContentSchemaExamples

  govuk_content_schema_examples.each do |example_name, content_item|
    test "can successfully render #{example_name} schema example" do
      get content_item['base_path'].sub(/^\//, '')

      assert_response :success
    end
  end
end
