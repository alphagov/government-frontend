require "test_helper"

class GoneHelperTest < ActionView::TestCase
  test "it renders a link to the full url" do
    request = stub(protocol: "http://", host: "www.dev.gov.uk")
    expected_html = link_to("http://www.dev.gov.uk/government/example", "/government/example")
    assert_equal(expected_html, alternative_path_link(request, "/government/example"))
  end
end
