require "test_helper"

class WorldwideOfficeTest < ActionDispatch::IntegrationTest
  test "includes the title of the organisation" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_title?("British Embassy Manila")
  end

  test "includes the title of the office contact" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_selector?("h2", text: "Consular section")
  end

  test "omits breadcrumbs" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_no_selector?(".govuk-breadcrumbs")
  end

  test "includes access details and contents" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_content? "Contents"
    assert_has_contents_list([
      { text: "Disabled access", id: "disabled-access" },
      { text: "Public Holidays for 2023", id: "public-holidays-for-2023" },
    ])

    assert page.has_content? "The British Embassy Manila is keen to ensure that our building and services are fully accessible to disabled members of the public."
  end

  test "omits access details and contents when they are not included in the content item" do
    content_item = get_content_example("worldwide_office")
    content_item["details"]["access_and_opening_times"] = nil

    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit_with_cachebust(content_item["base_path"])

    assert page.has_selector?("h2", text: "Consular section")
    assert_not page.has_content? "Contents"
  end

  test "includes the address" do
    setup_and_visit_content_item("worldwide_office")

    within find("address", match: :first) do
      assert page.has_content? "British Embassy Manila"
      assert page.has_content? "120 Upper McKinley Road, McKinley Hill"
      assert page.has_content? "Taguig City"
      assert page.has_content? "Manila"
      assert page.has_content? "1634"
      assert page.has_content? "Philippines"
    end
  end

  test "includes the contact details" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_content? "Email"
    assert page.has_link? "ukinthephilippines@fco.gov.uk"

    assert page.has_content? "Contact form"
    assert page.has_link? "http://www.gov.uk/cont...", href: "http://www.gov.uk/contact-consulate-manila"

    assert page.has_content? "Telephone"
    assert page.has_content? "+63 (02) 8 858 2200 / +44 20 7136 6857 (line open 24/7)"
  end

  test "includes the contact comments" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_content? "24/7 consular support is available by telephone for all routine enquiries and emergencies."
  end

  test "includes the logo and formatted name of the worldwide organisation as a link" do
    setup_and_visit_content_item("worldwide_office")

    assert_has_component_organisation_logo
    assert_has_component_title("British Embassy\nManila")
    assert page.has_link? "British EmbassyManila", href: "/world/organisations/british-embassy-manila"
  end

  test "includes the world locations and sponsoring organisations" do
    setup_and_visit_content_item("worldwide_office")

    within find(".worldwide-organisation-header__metadata", match: :first) do
      assert page.has_content? "Location:"
      assert page.has_link? "Philippines", href: "/world/philippines/news"
      assert page.has_link? "Palau", href: "/world/palau/news"

      assert page.has_content? "Part of:"
      assert page.has_link? "Foreign, Commonwealth & Development Office", href: "/government/organisations/foreign-commonwealth-development-office"
    end
  end

  test "omits the world locations and sponsoring organisations when they are absent" do
    content_item = get_content_example("worldwide_office")
    content_item["links"]["worldwide_organisation"][0]["links"]["sponsoring_organisations"] = nil
    content_item["links"]["worldwide_organisation"][0]["links"]["world_locations"] = nil

    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit_with_cachebust(content_item["base_path"])

    within find(".worldwide-organisation-header__metadata", match: :first) do
      assert_not page.has_content? "Location:"
      assert_not page.has_content? "Part of:"
    end
  end
end
