require 'test_helper'

class HelpPageTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item('help_page')
    assert page.has_text?(@content_item["title"])

    # assert page.has_text?("Last updated: 16 December 2014")
    assert_has_component_govspeak(@content_item["details"]["body"].squish)
  end

  test "related links are rendered" do
    setup_and_visit_content_item('help_page')
    within shared_component_selector("related_items") do
      related = @content_item["links"]["ordered_related_items"].first
      related_page = JSON.parse(page.text).fetch("sections").last["items"].first
      assert_equal related["title"], related_page["title"]
      assert_equal related["base_path"], related_page["url"]
    end
  end
end
