require "presenter_test_helper"

class TravelAdviceWithoutSummaryPresenterTest
  class PresentedTravelAdvice < PresenterTestCase
    def schema_name
      "travel_advice"
    end

    test "has parts" do
      assert presented_item("full-country-without-summary").is_a?(ContentItem::Parts)
    end

    test "part slug set to nil when content item has parts but base path requested" do
      assert_not presented_item("full-country-without-summary").requesting_a_part?
      assert presented_item("full-country-without-summary").part_slug.nil?
    end

    test "part slug set to last segment of requested content item path when content item has parts" do
      example = schema_item("full-country-without-summary")
      first_part = example["details"]["parts"][1]
      presented = presented_item("full-country-without-summary", first_part["slug"])

      assert presented.requesting_a_part?
      assert_equal presented.part_slug, first_part["slug"]
      assert presented.has_valid_part?
    end

    test "knows when an invalid part has been requested" do
      presented = presented_item("full-country-without-summary", "not-a-valid-part")

      assert presented.requesting_a_part?
      assert_equal presented.part_slug, "not-a-valid-part"
      assert_not presented.has_valid_part?
    end

    test "presents unique titles for each part" do
      example = schema_item("full-country-without-summary")
      presented = presented_item("full-country-without-summary")
      assert_equal example["title"], presented.page_title

      first_part = example["details"]["parts"].first
      presented_part = presented_item("full-country-without-summary", first_part["slug"])
      assert_equal "#{first_part['title']} - #{example['title']}", presented_part.page_title
    end

    test "presents withdrawn in the title for withdrawn content" do
      presented_item = presented_item("full-country-without-summary", nil, "withdrawn_notice" => { "explanation": "Withdrawn", "withdrawn_at": "2014-08-22T10:29:02+01:00" })
      assert_equal "[Withdrawn] Albania travel advice", presented_item.page_title
    end

    test "presents the first part as the current part when no part slug provided and no summary included in the details" do
      example = schema_item("full-country-without-summary")
      presented = presented_item("full-country-without-summary")

      assert presented.no_part_slug_provided?
      assert_equal "Safety and security", presented.current_part_title
      assert_equal example["details"]["parts"].first["body"], presented.current_part_body
    end

    test "presents the current part when a part slug is provided for country without summary" do
      example_parts = schema_item("full-country-without-summary")["details"]["parts"]
      first_part = example_parts[1]
      presented = presented_item("full-country-without-summary", first_part["slug"])

      assert_not presented.no_part_slug_provided?
      assert presented.has_valid_part?
      assert_equal first_part["title"], presented.current_part_title
      assert_equal first_part["body"], presented.current_part_body
    end

    test "presents first part when part slug is provided for country without summary" do
      example_parts = schema_item("full-country-without-summary")["details"]["parts"]
      first_part = example_parts.first
      presented = presented_item("full-country-without-summary", first_part["slug"])

      assert_not presented.no_part_slug_provided?
      assert_equal first_part["title"], presented.current_part_title
      assert_equal first_part["body"], presented.current_part_body
    end

    test "marks parts not in the content item as invalid" do
      example_part_slugs = schema_item("full-country-without-summary")["details"]["parts"].map { |part| part["slug"] }
      presented = presented_item("full-country-without-summary", "not-a-valid-part")

      assert_not example_part_slugs.include?("not-a-valid-part")
      assert_not presented.has_valid_part?
    end

    test "the summary is included as the first navigation item" do
      first_nav_item = presented_item("full-country-without-summary").parts_navigation.first.first
      assert_equal "Safety and security", first_nav_item
    end

    test "navigation items are presented as trackable links unless they are the current part" do
      example = schema_item("full-country-without-summary")
      current_part = example["details"]["parts"][1]

      first_part_presented = presented_item("full-country-without-summary", current_part["slug"])
      navigation_items = first_part_presented.parts_navigation

      first_part_nav_item = navigation_items[0][0]
      current_part_nav_item = navigation_items[0][1]
      another_part_nav_item = navigation_items[0][2]

      assert_equal first_part_nav_item,
                   "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" data-track-action=\"content_item 1\" "\
                   "data-track-label=\"/foreign-travel-advice/albania\" "\
                   "data-track-options=\"{&quot;dimension29&quot;:&quot;Safety and security&quot;}\" "\
                   "href=\"/foreign-travel-advice/albania\">Safety and security</a>"
      assert_equal current_part_nav_item, current_part["title"]
      assert_equal another_part_nav_item,
                   "<a class=\"govuk-link\" data-track-category=\"contentsClicked\" data-track-action=\"content_item 3\" "\
                   "data-track-label=\"/foreign-travel-advice/albania/local-laws-and-customs\" "\
                   "data-track-options=\"{&quot;dimension29&quot;:&quot;Local laws and customs&quot;}\" "\
                   "href=\"/foreign-travel-advice/albania/local-laws-and-customs\">Local laws and customs</a>"
    end

    test "navigation items link to all parts" do
      parts = schema_item("full-country-without-summary")["details"]["parts"]
      part_links = presented_item("full-country-without-summary").parts_navigation.flatten

      assert_equal parts.size, part_links.size
      assert part_links[1].include?(parts[1]["title"])
      assert part_links[1].include?(parts[1]["slug"])
    end

    test "part navigation is in one group when 3 or fewer navigation items" do
      example = schema_item("full-country-without-summary")

      example["details"]["parts"] = example["details"]["parts"].first(4)
      assert_equal 2, presented_item("full-country-without-summary", nil, example).parts_navigation.size

      example["details"]["parts"] = example["details"]["parts"].first(3)
      assert_equal 1, presented_item("full-country-without-summary", nil, example).parts_navigation.size

      example["details"]["parts"] = []
      assert_equal 0, presented_item("full-country-without-summary", nil, example).parts_navigation.size
    end

    test "part navigation is split into two groups" do
      assert_equal 2, presented_item("full-country-without-summary").parts_navigation.size
    end

    test "the second list of parts starting index continues on from the first list" do
      presented = presented_item("full-country-without-summary")
      assert_equal presented.parts_navigation.first.size + 1, presented.parts_navigation_second_list_start
    end

    test "presents an email signup link" do
      assert_equal schema_item("full-country-without-summary")["details"]["email_signup_link"], presented_item("full-country-without-summary").email_signup_link
    end

    test "presents a feed link" do
      assert_equal "#{schema_item('full-country-without-summary')['base_path']}.atom", presented_item("full-country-without-summary").feed_link
    end

    test "presents a print link" do
      assert_equal "#{schema_item('full-country-without-summary')['base_path']}/print", presented_item("full-country-without-summary").print_link
    end

    test "presents country name" do
      assert_equal schema_item("full-country-without-summary")["details"]["country"]["name"], presented_item("full-country-without-summary").country_name
    end

    test "#ireland?" do
      example = schema_item("full-country-without-summary")
      example["details"]["country"]["name"] = "Ireland"

      assert_equal true, presented_item("full-country-without-summary", nil, example).ireland?
    end

    test "presents only next navigation when on the summary" do
      example = schema_item("full-country-without-summary")
      parts = example["details"]["parts"]
      nav = presented_item("full-country-without-summary").previous_and_next_navigation
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
      example = schema_item("full-country-without-summary")
      parts = example["details"]["parts"]
      nav = presented_item("full-country-without-summary", parts[1]["slug"]).previous_and_next_navigation
      expected_nav = {
        next_page: {
          url: "#{example['base_path']}/#{parts[2]['slug']}",
          title: "Next",
          label: parts[2]["title"],
        },
        previous_page: {
          url: example["base_path"],
          title: "Previous",
          label: "Safety and security",
        },
      }

      assert_equal nav, expected_nav
    end

    test "presents only previous navigation when last part" do
      example = schema_item("full-country-without-summary")
      parts = example["details"]["parts"]
      nav = presented_item("full-country-without-summary", parts.last["slug"]).previous_and_next_navigation
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
      example = schema_item("full-country-without-summary")
      example["details"]["alert_status"] = %w[avoid_all_but_essential_travel_to_parts avoid_all_travel_to_parts]
      assert present_example(example).alert_status.include?("advise against all but essential travel")
      assert present_example(example).alert_status.include?("advise against all travel to parts")
    end

    test "metadata uses today for 'Still current at'" do
      presented = presented_item("full-country-without-summary").metadata[:other]["Still current at"]

      assert Date.parse(presented).today?
    end

    test "metadata uses review date for 'Updated'" do
      schema_updated = schema_item("full-country-without-summary")["details"]["reviewed_at"]
      presented_updated = presented_item("full-country-without-summary").metadata[:other]["Updated"]

      assert Date.parse(schema_updated) == Date.parse(presented_updated)
    end

    test "metadata uses updated date when no review date" do
      example = schema_item("full-country-without-summary")
      schema_updated = example["details"]["updated_at"]
      example["details"].delete("reviewed_at")
      presented_updated = presented_item("full-country-without-summary", nil, example).metadata[:other]["Updated"]

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
      presented = presented_item("full-country-without-summary")
      example = schema_item("full-country-without-summary")

      example_map_url = example["details"]["image"]["url"]
      presented_map_url = presented.map["url"]

      example_map_download_url = example["details"]["document"]["url"]
      presented_map_download_url = presented.map_download_url

      assert_equal example_map_url, presented_map_url
      assert_equal example_map_download_url, presented_map_download_url
    end

    test "handles travel advice without maps" do
      example = schema_item("full-country-without-summary")
      example["details"].delete("image")
      example["details"].delete("document")
      presented = presented_item("full-country-without-summary", nil, example)

      assert_nil presented.map
      assert_nil presented.map_download_url
    end

    test "formats change description for an atom feed" do
      example = schema_item("full-country-without-summary")
      example["details"]["change_description"] = "Test<br>XML"
      assert_equal "<p>Test&lt;br&gt;XML</p>", present_example(example).atom_change_description
    end

    test "presents all parts including summary for the print view" do
      example_parts = schema_item("full-country-without-summary")["details"]["parts"]
      parts = presented_item("full-country-without-summary").parts.clone
      first_part = parts.first

      parts.each_with_index do |part, i|
        assert_equal example_parts[i]["body"], part["body"]
        assert_equal example_parts[i]["slug"], part["slug"]
      end
      assert_equal "Safety and security", first_part["title"]
      assert_equal schema_item("full-country-without-summary")["details"]["parts"].first["body"], first_part["body"]
    end

  private

    def present_latest(latest)
      with_custom_change_description = {
        "details" => {
          "change_description" => latest,
        },
      }
      presented = presented_item("full-country-without-summary", nil, with_custom_change_description)
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
