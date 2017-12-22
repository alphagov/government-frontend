require 'test_helper'

class AnswerTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "renders title and body" do
    setup_and_visit_content_item('answer')
    assert page.has_text?(@content_item["title"])
    assert_has_component_govspeak(@content_item["details"]["body"])
    # assert page.has_text?("Diweddarwyd diwethaf: 28 Mai 2015")
  end

  test "related links are rendered" do
    setup_and_visit_content_item('answer')

    related_links = @content_item["details"]["external_related_links"].first

    within(".app-c-related-navigation") do
      assert page.has_css?('.app-c-related-navigation__section-link--other[href="' + related_links["url"] + '"]', text: related_links["title"])
    end
  end
end
