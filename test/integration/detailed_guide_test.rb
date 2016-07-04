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
    assert_has_component_document_footer_pair("part_of", [link1, link2])
    assert page.has_css?(".back-to-content")
  end

  test "withdrawn detailed guide" do
    setup_and_visit_content_item('withdrawn_detailed_guide')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    within ".withdrawal-notice" do
      assert page.has_text?('This guidance was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "shows related detailed guides" do
    setup_and_visit_content_item('political_detailed_guide')
    assert_has_component_document_footer_pair("Related guides", ['<a href="/guidance/offshore-wind-part-of-the-uks-energy-mix">Offshore wind: part of the UK&#39;s energy mix</a>'])
  end

  test "shows related mainstream content" do
    setup_and_visit_content_item('related_mainstream_detailed_guide')

    within ".related-mainstream-content" do
      assert page.has_text?('Too much detail?')
      assert page.has_css?('a[href="/overseas-passports"]', text: 'Overseas British passport applications')
      assert page.has_css?('a[href="/report-a-lost-or-stolen-passport"]', text: 'Cancel a lost or stolen passport')
    end
  end

  test "historically political detailed guide" do
    setup_and_visit_content_item('political_detailed_guide')

    within ".history-notice" do
      assert page.has_text?('This guidance was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end

  test 'detailed guide that only applies to a set of nations' do
    setup_and_visit_content_item('national_applicability_detailed_guide')

    assert_has_component_metadata_pair('Applies to', 'England')
  end

  test 'detailed guide that only applies to a set of nations, with alternative urls' do
    setup_and_visit_content_item('national_applicability_alternative_url_detailed_guide')

    assert_has_component_metadata_pair('Applies to', 'England, Scotland, and Wales (see guidance for <a href="http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for" rel="external">Northern Ireland</a>)')
  end

  test "translated detailed guide" do
    setup_and_visit_content_item('translated_detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_css?('.available-languages')
  end
end
