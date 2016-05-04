require 'test_helper'

class PublicationTest < ActionDispatch::IntegrationTest
  test "publication" do
    setup_and_visit_content_item('publication')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within '[aria-labelledby="details-title"]' do
      assert_has_component_govspeak(@content_item["details"]["body"])
    end

    assert_has_component_metadata_pair("first_published", "3 May 2016")
    link1 = "<a href=\"/government/organisations/environment-agency\">Environment Agency</a>"
    assert_has_component_metadata_pair("from", [link1])
    assert_has_component_document_footer_pair("from", [link1])
  end

  test "renders a govspeak block for attachments" do
    setup_and_visit_content_item('publication')
    within '[aria-labelledby="documents-title"]' do
      assert_has_component_govspeak(@content_item["details"]["documents"].join(''))
    end
  end
end
