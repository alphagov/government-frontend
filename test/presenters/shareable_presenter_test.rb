require 'test_helper'
include ERB::Util

class DummyContentItem
  include Shareable
  attr_accessor :content_item, :title

  def initialize
    @content_item = {}
    @content_item["base_path"] = "/a/base/path"
    @title = "A Title"
  end
end

class ShareablePresenterTest < ActiveSupport::TestCase
  def expected_path
    url_encode(Plek.current.website_root + "/a/base/path")
  end

  test 'presents the twitter share url' do
    expected_twitter_url = "https://twitter.com/share?url=#{expected_path}&text=A%20Title"
    actual = DummyContentItem.new.share_urls[:twitter]
    assert_equal expected_twitter_url, actual
  end

  test 'presents the facebook share url' do
    expected_facebook_url = "https://www.facebook.com/sharer/sharer.php?u=#{expected_path}"
    actual = DummyContentItem.new.share_urls[:facebook]
    assert_equal expected_facebook_url, actual
  end
end
