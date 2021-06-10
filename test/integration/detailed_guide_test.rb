require "test_helper"

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "detailed guide" do
    setup_and_visit_content_item("detailed_guide")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_metadata(
      published: "12 June 2014",
      last_updated: "18 February 2016",
      from: {
        "HM Revenue & Customs": "/government/organisations/hm-revenue-customs",
      },
    )
  end

  test "renders back to contents elements" do
    setup_and_visit_content_item("detailed_guide")

    assert page.has_css?(".app-c-back-to-top[href='#contents']")
  end

  test "withdrawn detailed guide" do
    setup_and_visit_content_item("withdrawn_detailed_guide")

    assert page.has_css?("title", text: "[Withdrawn]", visible: false)

    assert page.has_text?("This guidance was withdrawn"), "is withdrawn"
    assert page.has_text?("This information has been archived as it is now out of date. For current information please go to")
    assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
  end

  test "historically political detailed guide" do
    setup_and_visit_content_item("political_detailed_guide")

    within ".app-c-banner" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "detailed guide that only applies to a set of nations" do
    setup_and_visit_content_item("national_applicability_detailed_guide")
    assert_has_important_metadata("Applies to:": "England")
  end

  test "detailed guide that only applies to a set of nations, with alternative urls" do
    setup_and_visit_content_item("national_applicability_alternative_url_detailed_guide")

    assert_has_important_metadata(
      'Applies to:':
        "England, Scotland, and Wales (see guidance for Northern Ireland)",
    )
  end

  test "translated detailed guide" do
    setup_and_visit_content_item("translated_detailed_guide")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_css?(".gem-c-translation-nav")
  end

  test "renders a contents list" do
    setup_and_visit_content_item("detailed_guide")
    assert page.has_css?(".gem-c-contents-list")
  end

  test "renders without contents list if it has fewer than 3 items" do
    setup_and_visit_content_item("national_applicability_alternative_url_detailed_guide")
    assert_not page.has_css?(".gem-c-contents-list")
  end

  test "conditionally renders a logo" do
    setup_and_visit_content_item("england-2014-to-2020-european-structural-and-investment-funds")

    assert page.has_css?(".metadata-logo[alt='European structural investment funds']")
  end

  test "renders FAQ structured data" do
    setup_and_visit_content_item("detailed_guide")
    faq_schema = find_structured_data(page, "FAQPage")

    assert_equal faq_schema["name"], @content_item["title"]
    assert_not_equal faq_schema["mainEntity"], []
  end

  test "renders brexit child taxon pages in special ways" do
    setup_and_visit_brexit_child_taxon("business")

    # hides the print links
    assert_not page.has_css?(".gem-c-print-link")
    assert_not page.has_content?("Print this page")

    # hides published by metadata
    assert_not page.has_css?(".gem-c-metadata")

    # renders description field as a custom link
    assert_not page.has_text?(@content_item["description"])
    link_text = "Brexit guidance for individuals and families"
    assert page.has_link?(link_text, href: ContentItem::BrexitHubPage::BREXIT_CITIZEN_PAGE_PATH)

    setup_and_visit_brexit_child_taxon("citizen")

    assert_not page.has_text?(@content_item["description"])
    link_text = "Brexit guidance for businesses"
    assert page.has_link?(link_text, href: ContentItem::BrexitHubPage::BREXIT_BUSINESS_PAGE_PATH)

    # adds GA tracking to the li links
    track_action = find_link("Foreign travel advice")["data-track-action"]
    track_category = find_link("Foreign travel advice")["data-track-category"]
    track_label = find_link("Foreign travel advice")["data-track-label"]

    assert_equal "/foreign-travel-advice", track_action
    assert_equal "brexit-citizen-page", track_category
    assert_equal "Travel to the EU", track_label

    # adds GA tracking to the description field links
    track_action = find_link("Brexit guidance for businesses")["data-track-action"]
    track_category = find_link("Brexit guidance for businesses")["data-track-category"]
    track_label = find_link("Brexit guidance for businesses")["data-track-label"]

    assert_equal ContentItem::BrexitHubPage::BREXIT_BUSINESS_PAGE_PATH, track_action
    assert_equal "brexit-citizen-page", track_category
    assert_equal "Guidance nav link", track_label
  end
end
