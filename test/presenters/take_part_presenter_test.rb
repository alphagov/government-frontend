require 'test_helper'

class TakePartPresenterTest < ActiveSupport::TestCase

  test 'presents the basic details of a content item' do
    assert_equal take_part['description'], presented_take_part.description
    assert_equal take_part['format'], presented_take_part.format
    assert_equal take_part['locale'], presented_take_part.locale
    assert_equal take_part['title'], presented_take_part.title
    assert_equal take_part['details']['body'], presented_take_part.body
  end

  def presented_take_part(overrides = {})
    TakePartPresenter.new(take_part.merge(overrides))
  end

  def take_part
    govuk_content_schema_example('take_part', 'take_part')
  end
end
