require "test_helper"

class GuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "guide header and navigation" do
    setup_and_visit_content_item("guide")

    assert page.has_css?("title", visible: false, text: @content_item["title"])
    assert_has_component_title(@content_item["title"])

    assert page.has_css?("h1", text: @content_item["details"]["parts"].first["title"])
    assert page.has_css?(".govuk-pagination")
    assert page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']", text: "View a printable version of the whole guide")
  end
end
