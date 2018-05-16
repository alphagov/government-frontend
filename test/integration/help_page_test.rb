require 'test_helper'

class HelpPageTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item('help_page')
    assert page.has_text?(@content_item["title"])

    assert page.has_text?("Last updated: 16 December 2014")
    assert_has_component_govspeak(@content_item["details"]["body"].squish)
  end
end
