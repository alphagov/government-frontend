require "test_helper"

class WebchatAvailabilityHelperTest < ActionView::TestCase
  tests WebchatAvailabilityHelper

  setup do
    @content_item = Object.new
    @content_item.stubs(:base_path).returns(HMRC_WEBCHAT_CONTACT_PATHS.first)
  end

  test "webchat_unavailable? indicates unavailability" do
    assert_not webchat_unavailable?(Time.zone.parse("2018-05-12 15:59 BST"))
    assert webchat_unavailable?(Time.zone.parse("2018-05-12 16:00 BST"))
    assert webchat_unavailable?(Time.zone.parse("2018-05-14 08:59 BST"))
    assert_not webchat_unavailable?(Time.zone.parse("2018-05-14 09:00 BST"))
  end
end
