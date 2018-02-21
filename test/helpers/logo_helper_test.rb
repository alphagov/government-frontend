require 'test_helper'

class LogoHelperTest < ActionView::TestCase
  include LogoHelper

  def stubbed_presenter(content_item = {})
    p = Object.new
    p.stubs(:content_item).returns(content_item)
    p
  end

  test "it creates an image tag for national statistics logo" do
    presenter = stubbed_presenter
    presenter.stubs(:national_statistics?).returns(true)
    expected = image_tag("national-statistics.png", alt: "National Statistics", class: "metadata-logo")

    assert_equal(expected, content_logo(presenter))
  end

  test "it creates an image tag based on image url" do
    presenter = stubbed_presenter("details" => { "image" => { "url" => "/foo-bar-baz.png" } })
    expected = image_tag("/foo-bar-baz.png", class: "metadata-logo")

    assert_equal(expected, content_logo(presenter))
  end

  test "it returns nil for no logo" do
    assert_nil content_logo(stubbed_presenter)
  end
end
