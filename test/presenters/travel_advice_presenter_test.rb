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
end
