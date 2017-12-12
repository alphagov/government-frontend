require 'test_helper'

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "detailed guide" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within(".app-c-publisher-metadata") do
      within(".app-c-publisher-metadata__other") do
        assert page.has_content?("From: HM Revenue & Customs")
        assert page.has_link?('HM Revenue & Customs', href: '/government/organisations/hm-revenue-customs')
      end
      within(".app-c-published-dates") do
        assert page.has_content?("Published 12 June 2014")
        assert page.has_content?("Last updated 18 February 2016")
      end
    end
    within(".app-c-published-dates__change-history") do
      within(".app-c-published-dates__change-item:first-child") do
        assert page.has_content?("18 February 2016 The second entry in the table Examples of salary sacrifice has been amended to correct the explanation of how much of the salary is subject to tax and National Insurance contributions.")
      end
      within(".app-c-published-dates__change-item:last-child") do
        assert page.has_content?("June 2014 First published.")
      end
    end
    # FIXME: 'Part of' links are moving
    #link1 = "<a href=\"/topic/business-tax/paye\">PAYE</a>"
    #link2 = "<a href=\"/topic/business-tax\">Business tax</a>"
    #assert_has_component_metadata_pair("part_of", [link1, link2])
    #assert_has_component_document_footer_pair("part_of", [link1, link2])
  end

  test "renders back to contents elements on page with contents list" do
    setup_and_visit_content_item('detailed_guide')
    assert page.has_css?(".app-c-back-to-top[href='#contents-list']")
  end

  test "withdrawn detailed guide" do
    setup_and_visit_content_item('withdrawn_detailed_guide')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)
    within ".app-c-notice" do
      assert page.has_text?('This guidance was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["withdrawn_notice"]["explanation"])
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end


  test "shows related detailed guides" do
    # FIXME: Related links are coming later
    skip
    setup_and_visit_content_item('political_detailed_guide')
    assert_has_component_document_footer_pair("Related guides", ['<a href="/guidance/offshore-wind-part-of-the-uks-energy-mix">Offshore wind: part of the UK&#39;s energy mix</a>'])
  end


  test "shows related mainstream content" do
    # FIXME: Related links are coming later
    skip
    setup_and_visit_content_item('related_mainstream_detailed_guide')
    within ".related-mainstream-content" do
      assert page.has_text?('Too much detail?')
      assert page.has_css?('a[href="/overseas-passports"]', text: 'Overseas British passport applications')
      assert page.has_css?('a[href="/report-a-lost-or-stolen-passport"]', text: 'Cancel a lost or stolen passport')
    end
  end

  test "historically political detailed guide" do
    setup_and_visit_content_item('political_detailed_guide')
    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end

  test 'detailed guide that only applies to a set of nations' do
    setup_and_visit_content_item('national_applicability_detailed_guide')
    within(".app-c-publisher-metadata__other") do
      assert page.has_content?("Applies to: England")
    end
  end

  test 'detailed guide that only applies to a set of nations, with alternative urls' do
    setup_and_visit_content_item('national_applicability_alternative_url_detailed_guide')
    within(".app-c-publisher-metadata__other") do
      assert page.has_content?("Applies to: England, Scotland, and Wales (see guidance for Northern Ireland)")
      assert page.has_link?('Northern Ireland', href: 'http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for')
    end
  end

  test "translated detailed guide" do
    setup_and_visit_content_item('translated_detailed_guide')
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?('.app-c-translation-nav')
  end
end
