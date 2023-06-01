require "test_helper"

class WorldwideOrganisationTest < ActionDispatch::IntegrationTest
  test "renders basic worldwide organisation page" do
    setup_and_visit_content_item("worldwide_organisation")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
  end

  test "omits breadcrumbs" do
    setup_and_visit_content_item("worldwide_organisation")

    assert page.has_no_selector?(".govuk-breadcrumbs")
  end

  test "renders the body content" do
    setup_and_visit_content_item("worldwide_organisation")
    assert page.has_selector?("#about-us")
    assert page.has_text?("Find out more on our UK and India")
  end
end
