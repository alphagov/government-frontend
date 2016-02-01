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

  test 'presents a breadcrumb using the parent topic event' do
    assert_equal [
      {title: "Home", url: "/"},
      {title: "Ebola virus: UK government response", url: "/government/topical-events/ebola-virus-government-response"}
    ], presented_topical_event_about_page.breadcrumbs
  end

  def presented_topical_event_about_page(type = 'topical_event_about_page', overrides = {})
    content_item = topical_event_about_page(type)
    TopicalEventAboutPagePresenter.new(content_item.merge(overrides))
  end

  def topical_event_about_page(type = 'topical_event_about_page')
    govuk_content_schema_example('topical_event_about_page', type)
  end
end
