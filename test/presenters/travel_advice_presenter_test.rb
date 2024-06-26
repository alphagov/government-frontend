require "presenter_test_helper"

class TravelAdvicePresenterTest
  class PresentedTravelAdvice < PresenterTestCase
    def schema_name
      "travel_advice"
    end

    test "has parts" do
      assert presented_item("full-country").is_a?(ContentItem::Parts)
    end

    test "part slug set to nil when content item has parts but base path requested" do
      assert_not presented_item("full-country").requesting_a_part?
      assert presented_item("full-country").part_slug.nil?
    end

    test "part slug set to last segment of requested content item path when content item has parts" do
      example = schema_item("full-country")
      second_part = example["details"]["parts"][1]
      presented = presented_item("full-country", second_part["slug"])

      assert presented.requesting_a_part?
      assert_equal presented.part_slug, second_part["slug"]
      assert presented.has_valid_part?
    end

    test "knows when an invalid part has been requested" do
      presented = presented_item("full-country", "not-a-valid-part")

      assert presented.requesting_a_part?
      assert_equal presented.part_slug, "not-a-valid-part"
      assert_not presented.has_valid_part?
    end

    test "presents unique titles for each part" do
      example = schema_item("full-country")
      presented = presented_item("full-country")
      assert_equal example["title"], presented.page_title

      first_part = example["details"]["parts"].first
      presented_part = presented_item("full-country", first_part["slug"])
      assert_equal "#{first_part['title']} - #{example['title']}", presented_part.page_title
    end

    test "presents withdrawn in the title for withdrawn content" do
      presented_item = presented_item("full-country", nil, "withdrawn_notice" => { "explanation": "Withdrawn", "withdrawn_at": "2014-08-22T10:29:02+01:00" })
      assert_equal "[Withdrawn] Albania travel advice", presented_item.page_title
    end

    test "presents the current part when a part slug is provided for country" do
      example_parts = schema_item("full-country")["details"]["parts"]
      second_part = example_parts[1]
      presented = presented_item("full-country", second_part["slug"])

      assert_not presented.no_part_slug_provided?
      assert presented.has_valid_part?
      assert_equal second_part["title"], presented.current_part_title
      assert_equal second_part["body"], presented.current_part_body
    end

    test "presents first part when part slug is provided for country" do
      example_parts = schema_item("full-country")["details"]["parts"]
      first_part = example_parts.first
      presented = presented_item("full-country", first_part["slug"])

      assert_not presented.no_part_slug_provided?
      assert_equal first_part["title"], presented.current_part_title
      assert_equal first_part["body"], presented.current_part_body
    end

    test "marks parts not in the content item as invalid" do
      example_part_slugs = schema_item("full-country")["details"]["parts"].map { |part| part["slug"] }
      presented = presented_item("full-country", "not-a-valid-part")

      assert_not example_part_slugs.include?("not-a-valid-part")
      assert_not presented.has_valid_part?
    end

    test "the first part is included as the first navigation item" do
      first_nav_item = presented_item("full-country").parts_navigation.first.first
      assert_equal "Summary", first_nav_item
    end

    test "navigation items link to all parts" do
      parts = schema_item("full-country")["details"]["parts"]
      part_links = presented_item("full-country").parts_navigation.flatten

      assert_equal parts.size, part_links.size
      assert part_links[1].include?(parts[1]["title"])
      assert part_links[1].include?(parts[1]["slug"])
    end

    test "part navigation is in one group when 3 or fewer navigation items" do
      example = schema_item("full-country")

      example["details"]["parts"] = example["details"]["parts"].first(4)
      assert_equal 2, presented_item("full-country", nil, example).parts_navigation.size

      example["details"]["parts"] = example["details"]["parts"].first(3)
      assert_equal 1, presented_item("full-country", nil, example).parts_navigation.size

      example["details"]["parts"] = []
      assert_equal 0, presented_item("full-country", nil, example).parts_navigation.size
    end

    test "part navigation is split into two groups" do
      assert_equal 2, presented_item("full-country").parts_navigation.size
    end

    test "the second list of parts starting index continues on from the first list" do
      presented = presented_item("full-country")
      assert_equal presented.parts_navigation.first.size + 1, presented.parts_navigation_second_list_start
    end

    test "presents an email signup link" do
      assert_equal schema_item("full-country")["details"]["email_signup_link"], presented_item("full-country").email_signup_link
    end

    test "presents a feed link" do
      assert_equal "#{schema_item('full-country')['base_path']}.atom", presented_item("full-country").feed_link
    end

    test "presents a print link" do
      assert_equal "#{schema_item('full-country')['base_path']}/print", presented_item("full-country").print_link
    end

    test "presents country name" do
      assert_equal schema_item("full-country")["details"]["country"]["name"], presented_item("full-country").country_name
    end

    test "#ireland?" do
      example = schema_item("full-country")
      example["details"]["country"]["name"] = "Ireland"

      assert_equal true, presented_item("full-country", nil, example).ireland?
    end

    test "presents only next navigation when on the summary" do
      example = schema_item("full-country")
      parts = example["details"]["parts"]
      nav = presented_item("full-country").previous_and_next_navigation
      expected_nav = {
        next_page: {
          url: "#{example['base_path']}/#{parts[1]['slug']}",
          title: "Next",
          label: parts[1]["title"],
        },
      }

      assert_equal nav, expected_nav
    end

    test "presents previous and next navigation" do
      example = schema_item("full-country")
      parts = example["details"]["parts"]
      nav = presented_item("full-country", parts[1]["slug"]).previous_and_next_navigation
      expected_nav = {
        next_page: {
          url: "#{example['base_path']}/#{parts[2]['slug']}",
          title: "Next",
          label: parts[2]["title"],
        },
        previous_page: {
          url: example["base_path"],
          title: "Previous",
          label: "Summary",
        },
      }

      assert_equal nav, expected_nav
    end

    test "presents only previous navigation when last part" do
      example = schema_item("full-country")
      parts = example["details"]["parts"]
      nav = presented_item("full-country", parts.last["slug"]).previous_and_next_navigation
      expected_nav = {
        previous_page: {
          url: "#{example['base_path']}/#{parts[-2]['slug']}",
          title: "Previous",
          label: parts[-2]["title"],
        },
      }

      assert_equal nav, expected_nav
    end

    test "presents alert statuses" do
      example = schema_item("full-country")
      example["details"]["alert_status"] = %w[avoid_all_but_essential_travel_to_parts avoid_all_travel_to_parts]

      presented = present_example(example)

      assert presented.alert_status.first.include?("advises against all but essential travel to parts of #{presented.country_name}")
      assert presented.alert_status.last.include?("advises against all travel to parts of #{presented.country_name}")
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
      presented_updated = presented_item("full-country", nil, example).metadata[:other]["Updated"]

      assert Date.parse(schema_updated) == Date.parse(presented_updated)
    end

    test "metadata avoids duplication of 'Latest update' from change description" do
      [
        { original: "Latest update: Changes", presented: "<span class=\"metadata__update\">Changes</span>" },
        { original: "Latest update - changes", presented: "<span class=\"metadata__update\">Changes</span>" },
        { original: "Latest update changes", presented: "<span class=\"metadata__update\">Changes</span>" },
        { original: "Latest Update: Summary of changes. Next sentence", presented: "<span class=\"metadata__update\">Summary of changes. Next sentence</span>" },
        { original: "Latest update: Changes\n\nMore changes", presented: "<span class=\"metadata__update\">Changes</span>\n\n<span class=\"metadata__update\">More changes</span>" },
      ].each do |i|
        assert_equal i[:presented], present_latest(i[:original])
      end

      assert_nil present_latest("")
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
      example["details"].delete("image")
      example["details"].delete("document")
      presented = presented_item("full-country", nil, example)

      assert_nil presented.map
      assert_nil presented.map_download_url
    end

    test "formats change description for an atom feed" do
      example = schema_item("full-country")
      example["details"]["change_description"] = "Test<br>XML"
      assert_equal "<p>Test&lt;br&gt;XML</p>", present_example(example).atom_change_description
    end

    test "presents all parts including summary for the print view" do
      example_parts = schema_item("full-country")["details"]["parts"]
      parts = presented_item("full-country").parts.clone
      first_part = parts.first

      parts.each_with_index do |part, i|
        assert_equal example_parts[i]["body"], part["body"]
        assert_equal example_parts[i]["slug"], part["slug"]
      end
      assert_equal "Summary", first_part["title"]
      assert_equal schema_item("full-country")["details"]["parts"].first["body"], first_part["body"]
    end

  private

    def present_latest(latest)
      with_custom_change_description = {
        "details" => {
          "change_description" => latest,
        },
      }
      presented = presented_item("full-country", nil, with_custom_change_description)
      presented.metadata[:other]["Latest update"]
    end

    def presented_item(type = schema_name, part_slug = nil, overrides = {})
      schema_example_content_item = schema_item(type)
      part_slug = "/#{part_slug}" if part_slug

      create_presenter(
        TravelAdvicePresenter,
        content_item: schema_example_content_item.merge(overrides),
        requested_path: "#{schema_example_content_item['base_path']}#{part_slug}",
      )
    end
  end
end
