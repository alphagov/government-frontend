require 'test_helper'

class ShortTextPresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a short text item' do
    assert_equal "the title", presented_short_text.title
    assert_equal "the format", presented_short_text.format
    assert_equal "the body", presented_short_text.body
  end

  private

  def presented_short_text
    ShortTextPresenter.new({
      "title"  => "the title",
      "details" => { "body" => "the body" },
      "format" => "the format",
    })
  end
end
