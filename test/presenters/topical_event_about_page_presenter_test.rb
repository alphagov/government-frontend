require 'test_helper'

class TopicalEventAboutPagePresenterTest < ActiveSupport::TestCase
  test 'presents the basic details of a content item' do
    assert_equal topical_event_about_page['description'], presented_topical_event_about_page.description
    assert_equal topical_event_about_page['format'], presented_topical_event_about_page.format
    assert_equal topical_event_about_page['title'], presented_topical_event_about_page.title
    assert_equal topical_event_about_page['details']['body'], presented_topical_event_about_page.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    assert_equal ['<a href="#response-in-the-uk">Response in the UK</a>',
                  '<a href="#response-in-africa">Response in Africa</a>',
                  '<a href="#advice-for-travellers">Advice for travellers</a>',
                  '<a href="#advice-for-medics">Advice for medics</a>',
                  '<a href="#advice-for-aid-workers">Advice for aid workers</a>',
                  '<a href="#how-you-can-help">How you can help</a>'
                 ], presented_topical_event_about_page.contents
  end

  test 'presents no contents when no headings in the body' do
    assert_equal [], presented_topical_event_about_page('slim').contents
  end

  test 'presents a breadcrumb and indicates the archive state of the parent topical event' do
    breadcrumbs = [
      { title: "Home", url: "/" },
      { title: "Ebola virus: UK government response", url: "/government/topical-events/ebola-virus-government-response" }
    ]

    travel_to(topical_event_end_date - 1) do
      assert_equal breadcrumbs, presented_topical_event_about_page.breadcrumbs
    end

    travel_to(topical_event_end_date) do
      breadcrumbs[1].merge!(title: "Ebola virus: UK government response (Archived)")
      assert_equal breadcrumbs, presented_topical_event_about_page.breadcrumbs
    end
  end

  test 'presents a breadcrumb if parent topic event has no end date' do
    breadcrumbs = [
      { title: "Home", url: "/" },
      { title: "Battle of the Somme Centenary", url: "/government/topical-events/battle-of-the-somme-centenary-commemorations" }
    ]

    refute topical_event_about_page('slim')['links']['parent'][0]['details']['end_date']
    assert_equal breadcrumbs, presented_topical_event_about_page('slim').breadcrumbs
  end

private

  def topical_event_end_date
    Date.parse(topical_event_about_page['links']['parent'][0]['details']['end_date'])
  end

  def presented_topical_event_about_page(type = 'topical_event_about_page')
    content_item = topical_event_about_page(type)
    TopicalEventAboutPagePresenter.new(content_item)
  end

  def topical_event_about_page(type = 'topical_event_about_page')
    govuk_content_schema_example('topical_event_about_page', type)
  end
end
