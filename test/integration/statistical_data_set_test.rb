require "test_helper"

class StatisticalDataSetTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item("statistical_data_set")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("This is not intended to be a comprehensive review of transport performance in London or Great Britain during the Games, but supplements evidence from other sources.")
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item("statistical_data_set")

    assert_has_metadata({
      published: "13 December 2012",
      from: { "Department for Transport": "/government/organisations/department-for-transport" },
    }, context_selector: ".metadata-column")

    assert_footer_has_published_dates("Published 13 December 2012")
  end

  test "renders withdrawn notification" do
    setup_and_visit_content_item("statistical_data_set_withdrawn")

    assert page.has_css?("title", text: "[Withdrawn]", visible: false)

    withdrawn_at = @content_item["withdrawn_notice"]["withdrawn_at"]

    within ".gem-c-notice" do
      assert page.has_text?("This statistical data set was withdrawn"), "is withdrawn"
      assert page.has_text?("Local area walking and cycling in England: 2014 to 2015")
      assert page.has_css?("time[datetime='#{withdrawn_at}']")
    end
  end

  test "historically political statistical data set" do
    setup_and_visit_content_item("statistical_data_set_political")

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "renders with contents list" do
    setup_and_visit_content_item("statistical_data_set")

    assert_has_contents_list([
      { text: "Olympics", id: "olympics" },
      { text: "Table TSGB1001", id: "table-tsgb1001" },
      { text: "Table TSGB1002", id: "table-tsgb1002" },
      { text: "Table TSGB1003", id: "table-tsgb1003" },
      { text: "Table TSGB1004", id: "table-tsgb1004" },
      { text: "Table TSGB1005", id: "table-tsgb1005" },
    ])
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("statistical_data_set")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
