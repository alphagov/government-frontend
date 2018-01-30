require 'test_helper'

class DetailedGuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "detailed guide" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_publisher_metadata(
      published: "Published 12 June 2014",
      last_updated: "Last updated 18 February 2016",
      history_link: true,
      metadata: {
        "From:": {
          "HM Revenue & Customs": "/government/organisations/hm-revenue-customs"
        }
      }
    )
  end

  test "renders back to contents elements" do
    setup_and_visit_content_item('detailed_guide')

    assert page.has_css?(".app-c-back-to-top[href='#contents']")
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

  test "renders related topics" do
    setup_and_visit_content_item('detailed_guide')

    assert_has_related_navigation([
      {
        section_name: "related-nav-topics",
        section_text: "Explore the topic",
        links: {
          "PAYE": "/topic/business-tax/paye",
          "Business tax": "/topic/business-tax",
        }
      }
    ])
  end

  test "shows related detailed guides" do
    setup_and_visit_content_item('political_detailed_guide')

    assert_has_related_navigation([
      {
        section_name: "related-nav-related_guides",
        section_text: "Detailed guidance",
        links: {
          "Offshore wind: part of the UK's energy mix":
            "/guidance/offshore-wind-part-of-the-uks-energy-mix"
        }
      }
    ])
  end

  test "shows related mainstream links" do
    setup_and_visit_content_item('related_mainstream_detailed_guide')

    assert_has_related_navigation([
      {
        section_name: "related-nav-related_items",
        links: {
          "Overseas British passport applications": "/overseas-passports",
          "Cancel a lost or stolen passport": "/report-a-lost-or-stolen-passport",
        }
      }
    ])
  end

  test "historically political detailed guide" do
    setup_and_visit_content_item('political_detailed_guide')

    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end

  test 'detailed guide that only applies to a set of nations' do
    setup_and_visit_content_item('national_applicability_detailed_guide')
    assert_has_important_metadata("Applies to:": "England")
  end

  test 'detailed guide that only applies to a set of nations, with alternative urls' do
    setup_and_visit_content_item('national_applicability_alternative_url_detailed_guide')

    assert_has_important_metadata(
      'Applies to:':
        'England, Scotland, and Wales (see guidance for Northern Ireland)'
    )
  end

  test "translated detailed guide" do
    setup_and_visit_content_item('translated_detailed_guide')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_css?('.app-c-translation-nav')
  end

  test "renders a contents list" do
    setup_and_visit_content_item("detailed_guide")
    assert page.has_css?(".app-c-contents-list")
  end

  test "renders without contents list if it has fewer than 3 items" do
    setup_and_visit_content_item("national_applicability_alternative_url_detailed_guide")
    refute page.has_css?(".app-c-contents-list")
  end
end
