require 'test_helper'

class AnswerTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item('answer')
    assert page.has_text?(@content_item["title"])
    assert_has_component_govspeak(@content_item["details"]["body"])
    assert page.has_text?("Last Updated: 28 Mai 2015")
  end

  test "related links are rendered" do
    setup_and_visit_content_item('answer')
    within shared_component_selector("related_items") do
      elsewhere = @content_item["details"]["external_related_links"].first
      elsewhere_page = JSON.parse(page.text).fetch("sections").last["items"].first
      assert_equal elsewhere["title"], elsewhere_page["title"]
      assert_equal elsewhere["url"], elsewhere_page["url"]
    end
  end
end
