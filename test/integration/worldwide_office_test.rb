require "test_helper"

class WorldwideOfficeTest < ActionDispatch::IntegrationTest
  test "includes the title of the organisation" do
    setup_and_visit_content_item("worldwide_office")

    assert page.has_title?("British Embassy Manila")
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

    assert_not page.has_content? "Contents"
  end
end
