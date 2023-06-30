require "test_helper"

class WorldwideCorporateInformationPageTest < ActionDispatch::IntegrationTest
  test "includes the title of the organisation" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert page.has_title?("British Embassy Manila")
  end

  test "omits breadcrumbs" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert page.has_no_selector?(".govuk-breadcrumbs")
  end

  test "renders rtl text direction when the locale is a rtl language" do
    I18n.stubs(:locale).returns(:ar)
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert page.has_css?("#wrapper.direction-rtl"), "has .direction-rtl class on #wrapper element"
  end

  test "includes the body and contents" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert page.has_content? "Contents"
    assert_has_contents_list([
      { text: "General information", id: "general-information" },
      { text: "Current work opportunities", id: "current-work-opportunities" },
    ])
    assert page.has_content?("Fair competition is at the centre of recruitment at the British Embassy Manila.")
  end

  test "includes the description" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert page.has_content? "The description for the worldwide corporate information page"
  end

  test "includes the logo and name of the worldwide organisation as a link" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert_has_component_organisation_logo
    assert page.has_link? "British Embassy Manila", href: "/world/organisations/british-embassy-manila"
  end

  test "includes the world locations and sponsoring organisations" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    within find(".worldwide-organisation-header__metadata", match: :first) do
      assert page.has_link? "Philippines", href: "/world/philippines/news"
      assert page.has_link? "Palau", href: "/world/palau/news"

      assert page.has_link? "Foreign, Commonwealth & Development Office", href: "/government/organisations/foreign-commonwealth-development-office"
    end
  end

  test "does not render the translations when there are no translations" do
    setup_and_visit_content_item("worldwide_corporate_information_page")

    assert_not page.has_text?("English")
  end

  test "renders the translations when there are translations" do
    setup_and_visit_content_item(
      "worldwide_corporate_information_page",
      {
        "links" => {
          "available_translations" =>
            [
              {
                "locale": "en",
                "base_path": "/world/organisations/british-embassy-madrid/about/recruitment",
              },
              {
                "locale": "es",
                "base_path": "/world/organisations/british-embassy-madrid/about/recruitment.es",
              },
            ],
        },
      },
    )

    assert page.has_text?("English")
    assert page.has_link?("Español", href: "/world/organisations/british-embassy-madrid/about/recruitment.es")
  end
end
