require "presenter_test_helper"

class CaseStudyPresenterTest < PresenterTestCase
  include ActionView::Helpers::UrlHelper

  def schema_name
    "case_study"
  end

  test "presents the basic details of a content item" do
    assert_equal schema_item["description"], presented_item.description
    assert_equal schema_item["schema_name"], presented_item.schema_name
    assert_equal schema_item["locale"], presented_item.locale
    assert_equal schema_item["title"], presented_item.title
    assert_equal schema_item["details"]["body"], presented_item.body
  end

  test "#published returns a formatted date of the day the content item became public" do
    assert_equal "17 December 2012", presented_item.published
  end

  test "#updated returns nil if the content item has no updates" do
    assert_nil presented_item.updated
  end

  test "#updated returns a formatted date of the last day the content item was updated" do
    assert_equal "21 March 2013", presented_case_study_with_updates.updated
  end

  test "#from returns links to lead organisations, supporting organisations and worldwide organisations" do
    with_organisations = {
      "details" => {
        "emphasised_organisations" => ["b56753d2-ae3f-480e-88b0-35b1934dfc5a"],
      },
      "links" => {
        "worldwide_organisations" => [{ "title" => "DFID Pakistan", "base_path" => "/government/world/organisations/dfid-pakistan" }],
        "organisations" => [
          { "title" => "Supporting org", "base_path" => "/orgs/supporting", "content_id" => "dc2beab0-4ee9-41e0-9a6f-9c586d50fa7e" },
          { "title" => "Lead org", "base_path" => "/orgs/lead", "content_id" => "b56753d2-ae3f-480e-88b0-35b1934dfc5a" },
        ],
      },
    }

    expected_from_links = [
      link_to("Lead org", "/orgs/lead", class: "govuk-link"),
      link_to("Supporting org", "/orgs/supporting", class: "govuk-link"),
      link_to("DFID Pakistan", "/government/world/organisations/dfid-pakistan", class: "govuk-link"),
    ]

    assert_equal expected_from_links, presented_item(schema_name, with_organisations).from
  end

  test "#part_of returns an array of document_collections, related policies and world locations" do
    with_extras = schema_item
    with_extras["links"]["document_collections"] = [
      { "title" => "Work Programme real life stories", "base_path" => "/government/collections/work-programme-real-life-stories" }
    ]
    with_extras["links"]["related_policies"] = [
      { "title" => "Cheese", "base_path" => "/policy/cheese" }
    ]

    expected_part_of_links = [
      link_to("Work Programme real life stories", "/government/collections/work-programme-real-life-stories", class: "govuk-link"),
      link_to("Cheese", "/policy/cheese", class: "govuk-link"),
      link_to("Pakistan", "/world/pakistan/news", class: "govuk-link"),
    ]
    assert_equal expected_part_of_links, presented_item(schema_name, with_extras).part_of
  end

  test "#history returns an empty array if the content item has no updates" do
    assert_equal [], presented_item.history
  end

  test "#history returns a formatted history if the content item has updates" do
    expected_history = [
      { display_time: "21 March 2013", note: "Something changed", timestamp: "2013-03-21 00:00:00 +0000" },
    ]

    assert_equal expected_history, presented_case_study_with_updates.history
  end

  test "#history returns an empty array if the content item is not published" do
    never_published = schema_item
    never_published["details"].delete("first_public_at")
    presented = CaseStudyPresenter.new(never_published)
    assert_equal [], presented.history
  end

  test "presents withdrawn notices" do
    example = schema_item("archived")
    presented = presented_item("archived")

    assert example.include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["withdrawn_notice"]["explanation"], presented.withdrawal_notice_component[:description_govspeak]
    assert_equal '<time datetime="2014-08-22T10:29:02+01:00">22 August 2014</time>', presented.withdrawal_notice_component[:time]
  end

  def presented_case_study_with_updates
    updated_date = Time.new(2013, 3, 21).to_s
    with_history = schema_item
    with_history["details"]["change_history"] = [{ "note" => "Something changed", "public_timestamp" => updated_date }]
    with_history["public_updated_at"] = updated_date

    presented_item(schema_name, with_history)
  end
end
