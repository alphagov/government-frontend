require 'test_helper'

class StatisticalDataSetTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('statistical_data_set')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item('statistical_data_set')
    assert_has_publisher_metadata(
      published: "Published 13 December 2012",
      metadata: {
        "From:": { "Department for Transport": "/government/organisations/department-for-transport" }
      }
    )
    assert_footer_has_published_dates("Published 13 December 2012")
  end

  test "render related side bar navigation" do
    setup_and_visit_content_item('statistical_data_set')
    assert_has_related_navigation(
      [
        {
          section_name: "related-nav-collections",
          section_text: "Collection",
          links: {
            "Transport Statistics Great Britain":
              "/government/collections/transport-statistics-great-britain"
          }
        },
      ]
    )

    assert_has_link_to_finder(
      "Related statistical data sets",
      "/government/statistics",
      "departments[]" => "department-for-transport",
      "topics[]" => "all"
    )
  end

  test "renders withdrawn notification" do
    setup_and_visit_content_item("statistical_data_set_withdrawn")

    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    withdrawn_notice_explanation = @content_item["withdrawn_notice"]["explanation"]
    withdrawn_at = @content_item["withdrawn_notice"]["withdrawn_at"]

    within ".app-c-notice" do
      assert page.has_text?("This statistical data set was withdrawn"), "is withdrawn"
      assert_has_component_govspeak(withdrawn_notice_explanation)
      assert page.has_css?("time[datetime='#{withdrawn_at}']")
    end
  end

  test "historically political statistical data set" do
    setup_and_visit_content_item('statistical_data_set_political')

    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
