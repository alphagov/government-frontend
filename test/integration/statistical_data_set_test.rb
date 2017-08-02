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

    assert_has_component_metadata_pair("first_published", "13 December 2012")
    link1 = "<a href=\"/government/organisations/department-for-transport\">Department for Transport</a>"
    assert_has_component_metadata_pair("from", [link1])
    assert_has_component_document_footer_pair("from", [link1])

    assert_has_component_metadata_pair("part_of", ["<a href=\"/government/collections/transport-statistics-great-britain\">Transport Statistics Great Britain</a>"])
    assert_has_component_document_footer_pair("part_of", ["<a href=\"/government/collections/transport-statistics-great-britain\">Transport Statistics Great Britain</a>"])
  end

  test "renders withdrawn notification" do
    setup_and_visit_content_item("statistical_data_set_withdrawn")

    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    withdrawn_notice_explanation = @content_item["withdrawn_notice"]["explanation"]
    withdrawn_at = @content_item["withdrawn_notice"]["withdrawn_at"]

    within ".withdrawal-notice" do
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
