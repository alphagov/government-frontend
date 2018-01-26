require 'presenter_test_helper'

class AnnouncementsTest < PresenterTestCase
  include Navigation::Announcements

  def stub_content_item(params = {})
    self.stubs(:content_item).returns(
      {
        "document_type" => "news_story",
        "links" => {
          "organisations" => [
            { "title" => "Cabinet Office", "base_path" => "/government/organisations/cabinet-office" }
          ],
          "policy_areas" => [
            { "title" => "Arts and culture", "base_path" => "/government/topics/arts-and-culture" }
          ]
        }
      }.merge(params)
    )
  end

  def expected(params = {})
    expected_params = {
      announcement_filter_option: "news-stories",
      departments: ["cabinet-office"],
      people: ["all"],
      topics: ["arts-and-culture"],
      world_locations: ["all"]
    }.merge(params)

    "/government/announcements?#{expected_params.to_query}"
  end

  test "finder_path_and_params" do
    stub_content_item

    assert_equal expected, finder_path_and_params
  end

  test "filtering by different document type" do
    stub_content_item("document_type" => "world_location_news_article")

    assert_equal expected, finder_path_and_params

    stub_content_item("document_type" => "fatality_notice")
    assert_equal expected(announcement_filter_option: "fatality-notices"), finder_path_and_params
  end

  test "filtering on government_document_supertype" do
    stub_content_item("government_document_supertype" => "speeches")

    assert_equal expected(announcement_filter_option: "speeches"), finder_path_and_params
  end
end
