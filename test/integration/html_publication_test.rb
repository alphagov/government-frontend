require 'test_helper'

class HtmlPublicationTest < ActionDispatch::IntegrationTest
  test "html publications" do
    setup_and_visit_content_item('published')
    assert_has_component_govspeak_html_publication(@content_item["details"]["body"])

    within ".publication-header" do
      assert page.has_text?(@content_item["details"]["format_sub_type"])
      assert page.has_text?(@content_item["title"])

      assert page.has_text?("Published 17 January 2016")

      assert page.has_text?("Contents")
      assert page.has_css?('ol.unnumbered')
    end
  end

  def assert_has_component_govspeak_html_publication(content)
    within shared_component_selector("govspeak_html_publication") do
      assert_equal content, JSON.parse(page.text).fetch("content")
    end
  end
end
