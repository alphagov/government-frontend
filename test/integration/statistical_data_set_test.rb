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
      "More statistical data sets from Department for Transport",
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

  test "renders with contents list" do
    setup_and_visit_content_item('statistical_data_set')

    assert_has_contents_list([
      { text: "Olympics", id: "olympics" },
      { text: "Table TSGB1001", id: "table-tsgb1001" },
      { text: "Table TSGB1002", id: "table-tsgb1002" },
      { text: "Table TSGB1003", id: "table-tsgb1003" },
      { text: "Table TSGB1004", id: "table-tsgb1004" },
      { text: "Table TSGB1005", id: "table-tsgb1005" },
    ])
  end

  test "renders without contents list if it has fewer than 3 items" do
    item = get_content_example("statistical_data_set")
    item["details"]["body"] = "<div class='govspeak'>
      <h2>Item one</h2><p>Content about item one</p>
      <h2>Item two</h2><p>Content about item two</p>
      </div>"

    content_store_has_item(item["base_path"], item.to_json)
    visit(item["base_path"])

    refute page.has_css?(".app-c-contents-list")
  end
end
