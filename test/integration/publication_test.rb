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
      assert_has_component_govspeak(@content_item["details"]["body"])
    end

    assert_has_link_to_finder(
      "More notices from Environment Agency",
      "/government/publications",
      "departments[]" => "environment-agency",
      "people[]" => "all",
      "publication_filter_option" => "notices",
      "topics[]" => "all",
      "world_locations[]" => "all"
    )
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
      assert_has_component_govspeak(@content_item["details"]["documents"].join(''))
    end
  end

  test "withdrawn publication" do
    setup_and_visit_content_item('withdrawn_publication')
    assert page.has_css?('title', text: "[Withdrawn]", visible: false)

    within ".app-c-notice" do
      assert page.has_text?('This publication was withdrawn'), "is withdrawn"
      assert_has_component_govspeak(@content_item["withdrawn_notice"]["explanation"])
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

  test "doesn't render government navigation for pages with taxonomy navigation" do
    NavigationType.any_instance.stubs(:should_present_taxonomy_navigation?).returns(true)
    setup_and_visit_content_item('publication')

    refute page.has_css?(shared_component_selector('government_navigation'))
  end

  test "renders government navigation for pages without taxonomy navigation" do
    NavigationType.any_instance.stubs(:should_present_taxonomy_navigation?).returns(false)
    setup_and_visit_content_item('publication')

    assert page.has_css?(shared_component_selector('government_navigation'))
  end
end
