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
      presented_item.field_of_operation.title
    )
    assert_equal(
      schema_item['links']['field_of_operation'].first['base_path'],
      presented_item.field_of_operation.path
    )
  end

  test 'is linkable' do
    assert presented_item.is_a?(Linkable)
  end

  test 'is updatable' do
    assert presented_item.is_a?(Updatable)
  end

  test 'it presents the body' do
    assert_equal schema_item['details']['body'], presented_item.body
  end
end
