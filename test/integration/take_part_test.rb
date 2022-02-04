require "test_helper"

class TakePartTest < ActionDispatch::IntegrationTest
  test "take part pages" do
    setup_and_visit_content_item("take_part")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_text?("There are roughly 20,000 local councillors in England. Councillors are elected to the local council to represent their own local community, so they must either live or work in the area.")
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("take_part")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
