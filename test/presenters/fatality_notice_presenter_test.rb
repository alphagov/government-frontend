require 'presenter_test_helper'

class FatalityNoticePresenterTest < PresenterTest
  def format_name
    "fatality_notice"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
  end

  test 'presents context based on field of operation' do
    assert(
      presented_item.context.include?('Operations in'),
      'should prefix context with "Operations in"'
    )
    assert(
      presented_item.context.include?(schema_item['links']['field_of_operation'][0]['title']),
      'should also include the first field of operation\'s title'
    )
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '23 March 1881', presented_item.published
  end

  test 'presents fields of operation' do
    assert(
      presented_item.field_of_operation.include?(
        '<a href="/government/fields-of-operation/zululand">Zululand</a>'
      ),
      'should return a link to the field of operation'
    )
  end

  test 'presents the MOD crest image' do
    assert_equal presented_item.image['path'], 'mod-crest.png'
  end
end
