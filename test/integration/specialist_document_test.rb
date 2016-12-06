require 'test_helper'

class SpecialistDocumentTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders from in metadata and document footer" do
    setup_and_visit_content_item('aaib-reports')

    aaib = "<a href=\"/government/organisations/air-accidents-investigation-branch\">Air Accidents Investigation Branch</a>"
    assert_has_component_metadata_pair("from", [aaib])
    assert_has_component_document_footer_pair("from", [aaib])
  end

  test "renders a contents list" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_contents_list([
      { text: "Summary", id: "summary" },
    ])
  end
end
