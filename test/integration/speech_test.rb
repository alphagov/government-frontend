require 'test_helper'

class SpeechTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('speech')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "translated speech" do
    setup_and_visit_content_item('speech-translated')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?('.app-c-translation-nav')
  end

  test "renders metadata and document footer, including speaker" do
    setup_and_visit_content_item('speech')

    assert_has_publisher_metadata(
      published: "Published 8 March 2016",
      metadata: {
        "From": {
          "Department of Energy & Climate Change and The Rt Hon Andrea Leadsom MP": nil,
          "Department of Energy": "/government/organisations/department-of-energy-climate-change",
          "The Rt Hon Andrea Leadsom MP": "/government/people/andrea-leadsom",
        }
      }
    )

    assert_has_important_metadata(
      "Delivered on":
        "2 February 2016 (Original script, may differ from delivered version)",
      "Location":
        "Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London"
    )

    assert_footer_has_published_dates("Published 8 March 2016")
  end

  test "renders related policy links" do
    setup_and_visit_content_item('speech-transcript')

    assert_has_related_navigation(
      section_name: "related-nav-policies",
      section_text: "Policy",
      links: {
        "Government transparency and accountability":
          "/government/policies/government-transparency-and-accountability",
        "Tax evasion and avoidance":
          "/government/policies/tax-evasion-and-avoidance"
      }
    )
  end

  test "renders related speech navigation" do
    setup_and_visit_content_item('speech')

    assert_has_link_to_finder(
      "Related speeches",
      "/government/announcements",
      "departments[]" => "department-of-energy-climate-change",
      "people[]" => "andrea-leadsom",
      "announcement_filter_option" => "speeches",
      "topics[]" => "energy",
      "world_locations[]" => "all"
    )
  end
end
