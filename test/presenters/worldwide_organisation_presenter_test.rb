require "presenter_test_helper"

class WorldwideOrganisationPresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  test "#title returns the title" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the body" do
    assert_equal schema_item["details"]["body"], presented_item.body
  end

  test "#world_location_links returns the world locations as a joined sentence of links" do
    expected_links =
      "<a class=\"govuk-link\" href=\"/world/india/news\">India</a> and " \
        "<a class=\"govuk-link\" href=\"/world/another-location/news\">Another location</a>"

    assert_equal expected_links, presented_item.world_location_links
  end

  test "#world_location_links returns nil when world locations are empty" do
    without_world_locations = schema_item
    without_world_locations["links"].delete("world_locations")

    presented = create_presenter(WorldwideOrganisationPresenter, content_item: without_world_locations)

    assert_nil presented.world_location_links
  end

  test "#sponsoring_organisation_links returns the sponsoring organisations as sentence of links" do
    expected_links =
      "<a class=\"sponsoring-organisation govuk-link\" href=\"/government/organisations/foreign-commonwealth-development-office\">Foreign, Commonwealth &amp; Development Office</a> and " \
        "<a class=\"sponsoring-organisation govuk-link\" href=\"/government/organisations/department-for-business-and-trade\">Department for Business and Trade</a>"

    assert_equal expected_links, presented_item.sponsoring_organisation_links
  end

  test "#sponsoring_organisation_links returns nil when sponsoring organisations are empty" do
    without_sponsoring_organisations = schema_item
    without_sponsoring_organisations["links"].delete("sponsoring_organisations")

    presented = create_presenter(WorldwideOrganisationPresenter, content_item: without_sponsoring_organisations)

    assert_nil presented.sponsoring_organisation_links
  end

  test "#social_media_links returns the social media accounts" do
    assert_equal schema_item["details"]["social_media_links"], presented_item.social_media_accounts
  end
end
