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

  test "renders the person in the primary role" do
    setup_and_visit_content_item("worldwide_organisation")
    assert page.has_link?("Karen Pierce DCMG", href: "https://www.integration.publishing.service.gov.uk/government/people/karen-pierce")
    assert page.has_css?("img[src=\"https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/583/s216_UKMissionGeneva__HMA_Karen_Pierce_-_uploaded.jpg\"]")
  end

  test "renders people in secondary and office roles" do
    setup_and_visit_content_item("worldwide_organisation")
    assert page.has_link?("Justin Sosne", href: "https://www.integration.publishing.service.gov.uk/government/people/justin-sosne")
    assert page.has_link?("Rachel Galloway", href: "https://www.integration.publishing.service.gov.uk/government/people/rachel-galloway")
  end

  test "doesn't render the people section if there are no appointed people" do
    setup_and_visit_content_item(
      "worldwide_organisation",
      { "links" => {
        "primary_role_person" => nil,
        "secondary_role_person" => nil,
        "office_staff" => nil,
      } },
    )
    assert_not page.has_text?("Our people")
  end
end
