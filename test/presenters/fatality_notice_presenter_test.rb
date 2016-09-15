require 'presenter_test_helper'

class FatalityNoticePresenterTest < PresenterTest
  def format_name
    "fatality_notice"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['description'], presented_item.description
  end

  test 'presents the field of operation' do
    assert_equal(
      schema_item['links']['field_of_operation'].first['title'],
      presented_item.field_of_operation
    )
  end
end
