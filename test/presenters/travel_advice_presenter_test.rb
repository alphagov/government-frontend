require 'presenter_test_helper'

class TravelAdvicePresenterTest
  class PresentedTravelAdvice < PresenterTestCase
    def format_name
      "travel_advice"
    end

    test "the summary is included as the first navigation item" do
      base_path = schema_item("full-country")["base_path"]
      first_nav_item = presented_item("full-country").parts_navigation.first.first

      assert_equal base_path, first_nav_item[:path]
      assert_equal 'Current travel advice', first_nav_item[:title]
    end

    test "navigation items link to all parts" do
      parts = schema_item("full-country")["details"]["parts"]
      part_links = presented_item("full-country").parts_navigation.flatten

      assert_equal parts.size + 1, part_links.size
      assert_equal parts[0]['title'], part_links[1][:title]
      assert part_links[1][:path].include?(parts[0]['slug'])
    end

    test "part navigation is in one group when 3 or fewer navigation items (2 parts + summary)" do
      example = schema_item("full-country")

      example["details"]["parts"] = example["details"]["parts"].first(3)
      assert_equal 2, presented_item("full-country", example).parts_navigation.size

      example["details"]["parts"] = example["details"]["parts"].first(2)
      assert_equal 1, presented_item("full-country", example).parts_navigation.size

      example["details"]["parts"] = []
      assert_equal 1, presented_item("full-country", example).parts_navigation.size
    end

    test "part navigation is split into two groups" do
      assert_equal 2, presented_item("full-country").parts_navigation.size
    end

    test "the second list of parts starting index continues on from the first list" do
      presented = presented_item("full-country")
      assert_equal presented.parts_navigation.first.size + 1, presented.parts_navigation_second_list_start
    end

    test "metadata uses today for 'Still current at'" do
      presented = presented_item("full-country").metadata[:other]["Still current at"]

      assert Date.parse(presented).today?
    end

    test "metadata uses review date for 'Updated'" do
      schema_updated = schema_item("full-country")["details"]["reviewed_at"]
      presented_updated = presented_item("full-country").metadata[:other]["Updated"]

      assert Date.parse(schema_updated) == Date.parse(presented_updated)
    end

    test "metadata uses updated date when no review date" do
      example = schema_item("full-country")
      schema_updated = example["details"]["updated_at"]
      example["details"].delete("reviewed_at")
      presented_updated = presented_item("full-country", example).metadata[:other]["Updated"]

      assert Date.parse(schema_updated) == Date.parse(presented_updated)
    end

    test "metadata avoids duplication of 'Latest update' from change description" do
      [
        { original: "Latest update: Changes", presented: "<p>Changes</p>" },
        { original: "Latest update - changes", presented: "<p>Changes</p>" },
        { original: "Latest update changes", presented: "<p>Changes</p>" },
        { original: "Latest Update: Summary of changes. Next sentence", presented: "<p>Summary of changes. Next sentence</p>" },
      ].each do |i|
        assert_equal i[:presented], present_latest(i[:original])
      end
    end

    test "presents a map image and download link" do
      presented = presented_item("full-country")
      example = schema_item("full-country")

      example_map_url = example["details"]["image"]["url"]
      presented_map_url = presented.map["url"]

      example_map_download_url = example["details"]["document"]["url"]
      presented_map_download_url = presented.map_download_url

      assert_equal example_map_url, presented_map_url
      assert_equal example_map_download_url, presented_map_download_url
    end

    test "handles travel advice without maps" do
      example = schema_item("full-country")
      example['details'].delete('image')
      example['details'].delete('document')
      presented = presented_item("full-country", example)

      assert_equal nil, presented.map
      assert_equal nil, presented.map_download_url
    end

  private

    def present_latest(latest)
      with_custom_change_description = {
        "details" => {
          "change_description" => latest,
        }
      }
      presented = presented_item("full-country", with_custom_change_description)
      presented.metadata[:other]["Latest update"]
    end
  end
end
