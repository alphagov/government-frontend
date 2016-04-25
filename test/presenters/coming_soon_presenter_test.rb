require 'presenter_test_helper'

class ComingSoonPresenterTest < PresenterTest
  def format_name
    "coming_soon"
  end

  test 'presents the basic details required to display a coming soon item' do
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['locale'], presented_item.locale
    assert_equal schema_item['details']['publish_time'], presented_item.publish_time
  end

  test '#formatted_publish_time' do
    assert_equal '09:30', presented_item.formatted_publish_time
  end

  test '#formatted_publish_date' do
    assert_equal '17 December 2014', presented_item.formatted_publish_date
  end
end
