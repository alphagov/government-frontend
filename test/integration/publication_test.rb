require "test_helper"

class PublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item(document_type: "statutory_guidance")
  end

  test "publication" do
    setup_and_visit_content_item("publication")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within "#details" do
      assert page.has_text?("Installation name: Leeming Biogas Facility")
    end
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item("publication")

    assert_has_metadata(
      published: "3 May 2016",
      from: {
        "Environment Agency": "/government/organisations/environment-agency",
        "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
      },
    )

    assert_has_structured_data(page, "Article")

    assert_footer_has_published_dates("Published 3 May 2016")
  end

  test "renders document attachments (as-is and directly)" do
    setup_and_visit_content_item("publication")
    within "#documents" do
      assert page.has_text?("Permit: Veolia ES (UK) Limited")
    end

    setup_and_visit_content_item("publication-with-featured-attachments")
    within "#documents" do
      assert page.has_text?("Number of ex-regular service personnel now part of FR20")
      assert page.has_css?(".gem-c-attachment")
    end
  end

  test "withdrawn publication" do
    setup_and_visit_content_item("withdrawn_publication")
    assert page.has_css?("title", text: "[Withdrawn]", visible: false)

    within ".gem-c-notice" do
      assert page.has_text?("This publication was withdrawn"), "is withdrawn"
      assert page.has_text?("guidance for keepers of sheep, goats and pigs")
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political publication" do
    setup_and_visit_content_item("political_publication")

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "national statistics publication shows a logo" do
    setup_and_visit_content_item("statistics_publication")
    assert page.has_css?('img[alt="National Statistics"]')
  end

  test "national statistics publication has correct structured data" do
    setup_and_visit_content_item("statistics_publication")
    assert_has_structured_data(page, "Dataset")
  end

  test "renders 'Applies to' block in important metadata when there are excluded nations" do
    setup_and_visit_content_item("statistics_publication")
    assert_has_devolved_nations_component("Applies to England", [
      {
        text: "Publication for Northern Ireland",
        alternative_url: "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm",
      },
      {
        text: "Publication for Scotland",
        alternative_url: "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS",
      },
      {
        text: "Publication for Wales",
        alternative_url: "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en",
      },
    ])
  end

  test "renders with the single page notification button" do
    setup_and_visit_content_item("publication")
    assert page.has_css?(".gem-c-single-page-notification-button")
  end

  test "does not render the single page notification button on exempt pages" do
    setup_and_visit_notification_exempt_page("publication")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
