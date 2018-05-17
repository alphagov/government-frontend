require 'test_helper'

class HelpPageTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item('help_page')

    assert page.has_text?(@content_item["title"])
    assert_has_component_govspeak(@content_item["details"]["body"].squish)
    assert_has_published_dates(@content_item["last_updated"])
  end
end
