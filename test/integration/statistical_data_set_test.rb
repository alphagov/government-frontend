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
end
