require 'test_helper'

class PublicationTest < ActionDispatch::IntegrationTest
  test "publication" do
    setup_and_visit_content_item('publication')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within '[aria-labelledby="details-title"]' do
      assert_has_component_govspeak(@content_item["details"]["body"])
    end
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item('publication')

    assert_has_component_metadata_pair("first_published", "3 May 2016")
    link1 = "<a href=\"/government/organisations/environment-agency\">Environment Agency</a>"
    link2 = "<a href=\"/government/people/eric-pickles\">The Rt Hon Sir Eric Pickles MP</a>"
    assert_has_component_metadata_pair("from", [link1, link2])
    assert_has_component_document_footer_pair("from", [link1, link2])

    assert_has_component_metadata_pair("part_of", ["<a href=\"/government/topical-events/anti-corruption-summit-london-2016\">Anti-Corruption Summit: London 2016</a>"])
    assert_has_component_document_footer_pair("part_of", ["<a href=\"/government/topical-events/anti-corruption-summit-london-2016\">Anti-Corruption Summit: London 2016</a>"])
  end

  test "renders a govspeak block for attachments" do
    setup_and_visit_content_item('publication')
    within '[aria-labelledby="documents-title"]' do
      assert_has_component_govspeak(@content_item["details"]["documents"].join(''))
    end
  end

  test "withdrawn publication" do
    setup_and_visit_content_item('withdrawn_publication')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    within ".withdrawal-notice" do
      assert page.has_text?('This publication was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["details"]["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['details']['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political publication" do
    setup_and_visit_content_item('political_publication')

    within ".history-notice" do
      assert page.has_text?('This publication was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
