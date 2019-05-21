require 'test_helper'

class PublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item(document_type: 'statutory_guidance')
  end

  test "publication" do
    setup_and_visit_content_item('publication')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within '[aria-labelledby="details-title"]' do
      assert page.has_text?("Installation name: Leeming Biogas Facility")
    end
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item('publication')

    assert_has_publisher_metadata(
      published: "Published 3 May 2016",
      metadata: {
        "From": {
          "Environment Agency": "/government/organisations/environment-agency",
          "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
        }
      }
    )

    assert_footer_has_published_dates("Published 3 May 2016")
  end

  test "renders a govspeak block for attachments" do
    setup_and_visit_content_item('publication')
    within '[aria-labelledby="documents-title"]' do
      assert page.has_text?("Permit: Veolia ES (UK) Limited")
    end
  end

  test "withdrawn publication" do
    setup_and_visit_content_item('withdrawn_publication')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    within ".gem-c-notice" do
      assert page.has_text?('This publication was withdrawn'), "is withdrawn"
      assert page.has_text?("guidance for keepers of sheep, goats and pigs")
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "historically political publication" do
    setup_and_visit_content_item('political_publication')

    within ".app-c-banner" do
      assert page.has_text?('This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government')
    end
  end

  test "national statistics publication shows a logo" do
    setup_and_visit_content_item('statistics_publication')
    assert page.has_css?('img[alt="National Statistics"]')
  end

  test "renders 'Applies to' block in important metadata when there are excluded nations" do
    setup_and_visit_content_item('statistics_publication')

    assert_has_important_metadata(
      "Applies to": {
        "England (see publications for Northern Ireland, Scotland, and Wales)": nil,
        "Northern Ireland":
          "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm",
        "Scotland": "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS",
        "Wales": "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en",
      }
    )
  end

  test "renders list of steps and uses contextual breadcrumbs if a publication is secondary to multiple step navs" do
    setup_tap_and_visit_content_item('best-practice-regulation') do |item|
      # Documents cause additional requests which were troublesome to stub
      # and are not related to this test
      item['details']['documents'] = []
    end
    assert page.has_text?('Part of')
    page.assert_selector('a', text: 'Learn to drive a car: step by step')
    page.assert_selector('a', text: 'Get a divorce: step by step')
    assert_equal 1, page.find_all('.govuk-breadcrumbs__list-item').count
    within('.govuk-breadcrumbs__list-item') do
      assert_selector('a', text: 'Home')
    end
  end

  test "renders step nav and step nav header if a publication is secondary to one step navs" do
    setup_tap_and_visit_content_item('best-practice-guidance') do |item|
      # Documents cause additional requests which were troublesome to stub
      # and are not related to this test
      item['details']['documents'] = []
    end
    assert page.has_css?('.gem-c-step-nav')

    within('.gem-c-step-nav') do
      assert_selector('h2', text: "Check you're allowed to drive")
      assert_selector('h2', text: "Get a provisional driving licence")
      assert_selector('h2', text: "Prepare for your theory test")
      assert_selector('h2', text: "Book and manage your theory test")
      assert_selector('h2', text: "Book and manage your driving test")
      assert_selector('h2', text: "When you pass")
    end

    assert page.has_css?('.gem-c-step-nav-header')
    within('.gem-c-step-nav-header') do
      assert_selector('.gem-c-step-nav-header__title', text: 'Learn to drive a car: step by step')
    end
  end
end
