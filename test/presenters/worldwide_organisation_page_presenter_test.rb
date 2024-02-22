require "presenter_test_helper"

class WorldwideOrganisationPagePresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  def requested_path
    "#{schema_item['base_path']}/#{schema_item.dig('details', 'page_parts', 0, 'slug')}"
  end

  def present_example(example)
    create_presenter(
      "WorldwideOrganisationPagePresenter".safe_constantize,
      content_item: example,
      requested_path:,
    )
  end

  test "#title returns the title of the page" do
    assert_equal "Personal information charter", presented_item.title
  end

  test "#summary returns the summary of the page" do
    assert_equal "Public holidays information about the British Deputy High Commission Hyderabad.", presented_item.summary
  end

  test "#body returns the body of the page" do
    assert_equal schema_item.dig("details", "page_parts", 0, "body"), presented_item.body
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
