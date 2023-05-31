require "presenter_test_helper"

class WorldwideOfficePresenterTest < PresenterTestCase
  def schema_name
    "worldwide_office"
  end

  test "#title returns the title of the schema item" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the access and opening times of the schema item" do
    assert_equal schema_item["details"]["access_and_opening_times"], presented_item.body
  end

  test "#contact returns the contact as an instance of #{WorldwideOrganisation::LinkedContactPresenter}" do
    assert presented_item.contact.is_a?(WorldwideOrganisation::LinkedContactPresenter)
  end

  test "#world_location_links returns the world locations as a joined sentence of links" do
    expected_links =
      "<a class=\"govuk-link\" href=\"/world/philippines/news\">Philippines</a> and "\
      "<a class=\"govuk-link\" href=\"/world/palau/news\">Palau</a>"

    assert_equal expected_links, presented_item.world_location_links
  end

  test "#world_location_links returns nil when world locations are empty" do
    without_world_locations = schema_item
    without_world_locations["links"]["worldwide_organisation"][0]["links"].delete("world_locations")

    presented = create_presenter(WorldwideOfficePresenter, content_item: without_world_locations)

    assert_nil presented.world_location_links
  end

  test "#sponsoring_organisation_links returns the sponsoring organisations as sentence of links" do
    expected_links =
      "<a class=\"sponsoring-organisation govuk-link\" href=\"/government/organisations/foreign-commonwealth-development-office\">Foreign, Commonwealth &amp; Development Office</a>"

    assert_equal expected_links, presented_item.sponsoring_organisation_links
  end

  test "#sponsoring_organisation_links returns nil when sponsoring organisations are empty" do
    without_sponsoring_organisations = schema_item
    without_sponsoring_organisations["links"]["worldwide_organisation"][0]["links"].delete("sponsoring_organisations")

    presented = create_presenter(WorldwideOfficePresenter, content_item: without_sponsoring_organisations)

    assert_nil presented.sponsoring_organisation_links
  end

  test "#sponsoring_organisation_logo returns the logo details of the item" do
    with_non_default_crest = schema_item
    sponsoring_organisation = first_sponsoring_organisation(with_non_default_crest)
    sponsoring_organisation["details"]["logo"]["crest"] = "dbt"

    presented = create_presenter(WorldwideOfficePresenter, content_item: with_non_default_crest)

    expected = { name: "British Embassy Manila", url: "/world/organisations/british-embassy-manila", crest: "dbt", brand: "foreign-commonwealth-development-office" }
    assert_equal expected, presented.organisation_logo
  end

  test "#sponsoring_organisation_logo returns default values when the crest and brand of the first sponsoring organisation are blank" do
    with_empty_logo = schema_item
    sponsoring_organisation = first_sponsoring_organisation(with_empty_logo)
    sponsoring_organisation["details"]["logo"]["crest"] = nil
    sponsoring_organisation["details"]["brand"] = nil

    presented = create_presenter(WorldwideOfficePresenter, content_item: with_empty_logo)

    expected = { name: "British Embassy Manila", url: "/world/organisations/british-embassy-manila", crest: "single-identity", brand: "single-identity" }
    assert_equal expected, presented.organisation_logo
  end

private

  def first_sponsoring_organisation(item)
    item["links"]["worldwide_organisation"][0]["links"]["sponsoring_organisations"][0]
  end
end
