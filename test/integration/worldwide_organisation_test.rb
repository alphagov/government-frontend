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

  test "renders rtl text direction when the locale is a rtl language" do
    I18n.stubs(:locale).returns(:ar)
    setup_and_visit_content_item("worldwide_organisation")

    assert page.has_css?("#wrapper.direction-rtl"), "has .direction-rtl class on #wrapper element"
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

  test "renders the navigational corporate information pages" do
    setup_and_visit_content_item("worldwide_organisation")
    assert page.has_link?("Complaints procedure", href: "https://www.integration.publishing.service.gov.uk/world/organisations/british-deputy-high-commission-hyderabad/about/complaints-procedure")
  end

  test "renders the secondary corporate information pages" do
    setup_and_visit_content_item("worldwide_organisation")
    assert page.has_link?("Personal information charter", href: "https://www.integration.publishing.service.gov.uk/world/organisations/british-deputy-high-commission-hyderabad/about/personal-information-charter")
  end

  test "doesn't render the corporate pages section if there are no pages to show" do
    setup_and_visit_content_item(
      "worldwide_organisation",
      {
        "links" => { "corporate_information_pages" => nil },
        "details" => { "secondary_corporate_information_pages" => "" },
      },
    )
    assert_not page.has_text?("Corporate information")
  end

  test "does not render the translations when there are no translations" do
    setup_and_visit_content_item("worldwide_organisation")

    assert_not page.has_text?("English")
  end

  test "renders the translations when there are translations" do
    setup_and_visit_content_item(
      "worldwide_organisation",
      {
        "links" => {
          "available_translations" =>
            [
              {
                "locale": "en",
                "base_path": "/world/uk-embassy-in-country",
              },
              {
                "locale": "de",
                "base_path": "/world/uk-embassy-in-country.de",
              },
            ],
        },
      },
    )

    assert page.has_text?("English")
    assert page.has_link?("Deutsch", href: "/world/uk-embassy-in-country.de")
  end

  test "renders the main office contact with a link to the office page" do
    setup_and_visit_content_item("worldwide_organisation")

    within("#contact-us") do
      assert page.has_text?("Contact us")
      assert page.has_content?("Torre Emperador Castellana")
      assert page.has_link?(I18n.t("contact.access_and_opening_times"), href: "https://www.integration.publishing.service.gov.uk/world/organisations/british-embassy-madrid/office/british-embassy")
    end
  end

  test "renders the home page offices without a link to the office page" do
    setup_and_visit_content_item("worldwide_organisation")

    within("#contact-us") do
      assert page.has_content?("Department for Business and Trade Dusseldorf")
      assert_not page.has_link?(I18n.t("contact.access_and_opening_times"), href: "https://www.integration.publishing.service.gov.uk/world/organisations/department-for-business-and-trade-germany/office/uk-trade-investment-duesseldorf")
    end
  end

  test "does not render the contacts section if there is no main office" do
    setup_and_visit_content_item(
      "worldwide_organisation",
      {
        "links" => { "main_office" => nil },
      },
    )
    assert_not page.has_text?("Contact us")
  end
end
