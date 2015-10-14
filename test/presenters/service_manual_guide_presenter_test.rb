require 'test_helper'

class ServiceManualGuidePresenterTest < ActiveSupport::TestCase
  test 'presents the basic details required to display a short text item' do
    assert_equal "the title", presented_short_text.title
    assert_equal "the format", presented_short_text.format
    assert_equal "the body", presented_short_text.body
    assert_equal [{"title" => "title", "href" => "href"}], presented_short_text.header_links
  end

  private

  def presented_short_text
    ServiceManualGuidePresenter.new({
      "title"  => "the title",
      "details" => { "body" => "the body", "header_links" => [{"title" => "title", "href" => "href"}]},
      "format" => "the format",
    })
  end
end
