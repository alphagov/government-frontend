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

    related_links = @content_item["links"]["ordered_related_items"].first

    within(".gem-c-related-navigation") do
      assert page.has_css?('.gem-c-related-navigation__section-link--other[href="' + related_links["base_path"] + '"]', text: related_links["title"])
    end
  end
end
