require 'test_helper'

class SpecialistDocumentTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item(document_type: 'aaib_report')
    setup_and_visit_random_content_item(document_type: 'raib_report')
    setup_and_visit_random_content_item(document_type: 'tax_tribunal_decision')
    setup_and_visit_random_content_item(document_type: 'cma_case')
  end

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

  test "renders published and updated in metadata and document footer" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    assert_has_component_metadata_pair("first_published", "2 April 2015")
    assert_has_component_metadata_pair("last_updated", "29 March 2016")

    assert_has_component_document_footer_pair("published", "2 April 2015")
    assert_has_component_document_footer_pair("updated", "29 March 2016")
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within shared_component_selector("document_footer") do
      component_args = JSON.parse(page.text)
      history = component_args.fetch("history")

      assert_equal history.first["note"], @content_item["details"]["change_history"].last["note"]
      assert_equal history.last["note"], @content_item["details"]["change_history"].first["note"]
      assert_equal history.size, @content_item["details"]["change_history"].size
    end
  end

  test "renders a contents list" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_contents_list([
      { text: "Summary", id: "summary" },
    ])
  end
end
