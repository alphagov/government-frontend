require 'test_helper'

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "detailed guide" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_metadata_pair("First published", "12 June 2014")
    assert_has_component_metadata_pair("Last updated", "18 February 2016, <a href=\"#history\">see all updates</a>")
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
end
