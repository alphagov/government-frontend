require "test_helper"

class RequestHelperTest < ActiveSupport::TestCase
  test "get_header returns nil when header does not exist" do
    header_val = RequestHelper.get_header("Govuk-Example-Header", {})

    assert_nil header_val
  end

  test "get_header returns header when header exists" do
    header_val = RequestHelper.get_header("Govuk-Example-Header", "HTTP_GOVUK_EXAMPLE_HEADER" => "this_is_a_test")

    assert_equal "this_is_a_test", header_val
  end

  test "headerise returns header with HTTP prefix, no dashes and all uppercase" do
    header_name = "Govuk-Example-Header"

    transformed_header_name = RequestHelper.headerise(header_name)

    assert_equal "HTTP_GOVUK_EXAMPLE_HEADER", transformed_header_name
  end
end
