require 'presenter_test_helper'

class StatisticsTest < PresenterTestCase
  include Navigation::Statistics

  def stub_content_item(params = {})
    self.stubs(:content_item).returns(
      {
        "schema_name" => "statistics",
        "links" => {
          "organisations" => [
            {
              "title" => "Office for National Statistics",
              "base_path" => "/government/organisations/office-for-national-statistics"
            }
          ],
          "policy_areas" => [
            {
              "title" => "Employment",
              "base_path" => "/government/topics/employment"
            }
          ]
        }
      }.merge(params)
    )
  end

  def expected(path = "/government/statistics", params = {})
    expected_params = {
      departments: ["office-for-national-statistics"],
      topics: ["employment"],
    }.merge(params)

    "#{path}?#{expected_params.to_query}"
  end

  test "finder_path_and_params" do
    self.stubs(:schema_name).returns("statistics")
    stub_content_item

    assert_equal expected, finder_path_and_params
  end

  test "finder_path_and_params for statistics announcements" do
    self.stubs(:schema_name).returns("statistics_announcement")
    stub_content_item

    assert_equal expected("/government/statistics/announcements"), finder_path_and_params
  end

  test "pluralised_document_type default" do
    stub_content_item
    self.stubs(:schema_name).returns("statistics")
    self.stubs(:document_type).returns("statistical_data_set")

    assert_equal "statistical data sets", pluralised_document_type
  end

  test "pluralise_document_type for announcements" do
    stub_content_item
    self.stubs(:schema_name).returns("statistics_announcement")

    assert_equal "statistics announcements", pluralised_document_type
  end
end
