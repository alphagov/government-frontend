require 'test_helper'

class ComingSoonPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a coming soon item' do
    assert_equal coming_soon['title'], presented_coming_soon.title
    assert_equal coming_soon['format'], presented_coming_soon.format
    assert_equal coming_soon['locale'], presented_coming_soon.locale
    assert_equal coming_soon['details']['publish_time'], presented_coming_soon.publish_time
  end

  test '#formatted_publish_time' do
    assert_equal '09:30', presented_coming_soon.formatted_publish_time
  end

  test '#formatted_publish_date' do
    assert_equal '17 December 2014', presented_coming_soon.formatted_publish_date
  end

private
  def presented_coming_soon(overrides={})
    ComingSoonPresenter.new(coming_soon.merge(overrides))
  end

  def coming_soon
    govuk_content_schema_example('coming_soon')
  end

end
