require 'test_helper'

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "detailed guide" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_metadata_pair("first_published", "12 June 2014")
    assert_has_component_metadata_pair("last_updated", "18 February 2016")
    link1 = "<a href=\"/topic/business-tax/paye\">PAYE</a>"
    link2 = "<a href=\"/topic/business-tax\">Business tax</a>"
    assert_has_component_metadata_pair("part_of", [link1, link2])
  end

  test "withdrawn detailed guide" do
    setup_and_visit_content_item('withdrawn_detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within ".withdrawal-notice" do
      assert page.has_text?('This guidance was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["details"]["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['details']['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "shows related detailed guides" do
    setup_and_visit_content_item('political_detailed_guide')
    assert_has_component_document_footer_pair("Related guides", ['<a href="/guidance/offshore-wind-part-of-the-uks-energy-mix">Offshore wind: part of the UK&#39;s energy mix</a>'])
  end

  test "historically political detailed guide" do
    setup_and_visit_content_item('political_detailed_guide')

    within ".history-notice" do
      assert page.has_text?('This guidance was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end
end
