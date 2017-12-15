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
  end

  test "renders metadata and document footer" do
    setup_and_visit_content_item('publication')

    within(".app-c-publisher-metadata") do
      assert page.has_css?(".app-c-published-dates", text: "Published 3 May 2016")

      within(".app-c-publisher-metadata__other") do
        assert page.has_link?("Environment Agency", href: "/government/organisations/environment-agency")
        assert page.has_link?("The Rt Hon Sir Eric Pickles MP", href: "/government/people/eric-pickles")
      end
    end

    within(".responsive-bottom-margin .app-c-published-dates") do
      assert page.has_content?("Published 3 May 2016")
    end
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

    within(".app-c-important-metadata") do
      assert page.has_content?("Applies to: England (see publications for Northern Ireland, Scotland, and Wales)")
      assert page.has_link?("Northern Ireland", href: "http://www.dsdni.gov.uk/index/stats_and_research/stats-publications/stats-housing-publications/housing_stats.htm")
      assert page.has_link?("Scotland", href: "http://www.scotland.gov.uk/Topics/Statistics/Browse/Housing-Regeneration/HSfS")
      assert page.has_link?("Wales", href: "http://wales.gov.uk/topics/statistics/headlines/housing2012/121025/?lang=en")
    end
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
