require "presenter_test_helper"

class WorldwideOrganisationPresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  test "description of primary_role_person should have spaces between roles" do
    presenter = create_presenter(WorldwideOrganisationPresenter, content_item: {
      "details" => { "people_role_associations" => [
        {
          "person_content_id" => "person_1",
          "role_appointments" => [
            {
              "role_appointment_content_id" => "role_apppointment_1",
              "role_content_id" => "role_1",
            },
            {
              "role_appointment_content_id" => "role_apppointment_2",
              "role_content_id" => "role_2",
            },
          ],
        },
      ] },
      "links" => {
        "primary_role_person" => [
          {
            "content_id" => "person_1",
            "details" => { "image" => {} },
            "links" => {},
          },
        ],
        "role_appointments" => [
          {
            "content_id" => "role_apppointment_1",
            "details" => { "current" => true },
            "links" => {},
          },
          {
            "content_id" => "role_apppointment_2",
            "details" => { "current" => true },
            "links" => {},
          },
        ],
        "roles" => [
          {
            "content_id" => "role_1",
            "title" => "Example Role 1",
          },
          {
            "content_id" => "role_2",
            "title" => "Example Role 2",
          },
        ],
      },
    })
    assert_equal "Example Role 1, Example Role 2", presenter.person_in_primary_role[:description]
  end

  test "description of people_in_non_primary_roles should have spaces between roles" do
    presenter = create_presenter(WorldwideOrganisationPresenter, content_item: {
      "details" => { "people_role_associations" => [
        {
          "person_content_id" => "person_1",
          "role_appointments" => [
            {
              "role_appointment_content_id" => "role_apppointment_1",
              "role_content_id" => "role_1",
            },
            {
              "role_appointment_content_id" => "role_apppointment_2",
              "role_content_id" => "role_2",
            },
          ],
        },
      ] },
      "links" => {
        "secondary_role_person" => [
          {
            "content_id" => "person_1",
            "details" => { "image" => {} },
            "links" => {},
          },
        ],
        "role_appointments" => [
          {
            "content_id" => "role_apppointment_1",
            "details" => { "current" => true },
            "links" => {},
          },
          {
            "content_id" => "role_apppointment_2",
            "details" => { "current" => true },
            "links" => {},
          },
        ],
        "roles" => [
          {
            "content_id" => "role_1",
            "title" => "Example Role 1",
          },
          {
            "content_id" => "role_2",
            "title" => "Example Role 2",
          },
        ],
      },
    })
    assert_equal "Example Role 1, Example Role 2", presenter.people_in_non_primary_roles.first[:description]
  end

  test "#title returns the title" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the body" do
    assert_equal schema_item["details"]["body"], presented_item.body
  end

  test "#world_location_links returns the world locations as a joined sentence of links" do
    expected_links =
      "<a class=\"govuk-link\" href=\"/world/india/news\">India with translation</a> and " \
        "<a class=\"govuk-link\" href=\"/world/another-location/news\">Another location with translation</a>"

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

  test "#main_office returns nil when there is no main office" do
    without_main_office = schema_item
    without_main_office["links"].delete("main_office")

    presented = create_presenter(WorldwideOrganisationPresenter, content_item: without_main_office)

    assert_nil presented.main_office
  end

  test "#home_page_offices returns an empty array when there are no home page offices" do
    without_home_page_offices = schema_item
    without_home_page_offices["links"].delete("home_page_offices")

    presented = create_presenter(WorldwideOrganisationPresenter, content_item: without_home_page_offices)

    assert_equal [], presented.home_page_offices
  end
end
