require 'presenter_test_helper'

class AnswerPresenterTest < PresenterTestCase
  def format_name
    "answer"
  end

  test 'presents the title' do
    assert_equal schema_item['title'], presented_item.title
  end

  test 'presents the body' do
    assert_equal schema_item['details']['body'], presented_item.body
  end

  test 'presents the ab_body' do
    assert_match /get-started/, presented_item.ab_body
  end
end
