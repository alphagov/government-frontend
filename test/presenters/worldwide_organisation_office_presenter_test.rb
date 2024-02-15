require "presenter_test_helper"

class WorldwideOrganisationOfficePresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  def requested_path
    "#{schema_item['base_path']}/#{schema_item.dig('details', 'main_office_parts', 0, 'slug')}"
  end

  def present_example(example)
    create_presenter(
      "WorldwideOrganisationOfficePresenter".safe_constantize,
      content_item: example,
      requested_path:,
    )
  end

  test "#title returns the title of the schema item" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the access and opening times of the schema item" do
    assert_equal schema_item.dig("details", "main_office_parts", 0, "access_and_opening_times"), presented_item.body
  end

  test "#contact returns the contact as an instance of #{WorldwideOrganisation::LinkedContactPresenter}" do
    assert presented_item.contact.is_a?(WorldwideOrganisation::LinkedContactPresenter)
  end

  test "#sponsoring_organisation_logo returns the logo details of the item" do
    with_non_default_crest = schema_item
    sponsoring_organisation = first_sponsoring_organisation(with_non_default_crest)
    sponsoring_organisation["details"]["logo"]["crest"] = "dbt"

    presented = present_example(with_non_default_crest)

    expected = { name: "British Deputy High Commission<br/>Hyderabad", url: "/world/uk-embassy-in-country", crest: "dbt", brand: "foreign-commonwealth-development-office" }
    assert_equal expected, presented.organisation_logo
  end

  test "#sponsoring_organisation_logo returns default values when the crest and brand of the first sponsoring organisation are blank" do
    with_empty_logo = schema_item
    sponsoring_organisation = first_sponsoring_organisation(with_empty_logo)
    sponsoring_organisation["details"]["logo"]["crest"] = nil
    sponsoring_organisation["details"]["brand"] = nil

    presented = present_example(with_empty_logo)

    expected = { name: "British Deputy High Commission<br/>Hyderabad", url: "/world/uk-embassy-in-country", crest: "single-identity", brand: "single-identity" }
    assert_equal expected, presented.organisation_logo
  end

  test "#sponsoring_organisation_logo returns default values when the sponsoring organisations are nil" do
    without_sponsoring_organisations = schema_item
    without_sponsoring_organisations["links"].delete("sponsoring_organisations")

    presented = present_example(without_sponsoring_organisations)

    expected = { name: "British Deputy High Commission<br/>Hyderabad", url: "/world/uk-embassy-in-country", crest: "single-identity", brand: "single-identity" }
    assert_equal expected, presented.organisation_logo
  end

private

  def first_sponsoring_organisation(item)
    item["links"]["sponsoring_organisations"][0]
  end
end
