require 'presenter_test_helper'

class TakePartPresenterTest < PresenterTestCase
  def format_name
    "take_part"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['locale'], presented_item.locale
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
  end
end
