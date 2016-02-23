require 'test_helper'

class HtmlPublicationPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details of a content item' do
    assert_equal html_publication['format'], presented_html_publication.format
    assert_equal html_publication['links']['parent'][0]['format_sub_type'], presented_html_publication.format_sub_type
    assert_equal html_publication['title'], presented_html_publication.title
    assert_equal html_publication['details']['body'], presented_html_publication.body
  end

  test 'presents the last change date' do
    published = presented_html_publication("published")
    assert_equal "Published 17 January 2016", published.last_changed

    updated = presented_html_publication("updated")
    assert_equal "Updated 2 February 2016", updated.last_changed
  end

  def presented_html_publication(type = 'published')
    content_item = html_publication(type)
    HtmlPublicationPresenter.new(content_item)
  end

  def html_publication(type = 'published')
    govuk_content_schema_example('html_publication', type)
  end
end
