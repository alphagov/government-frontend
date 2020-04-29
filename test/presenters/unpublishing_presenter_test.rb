require "presenter_test_helper"

class UnpublishingPresenterTest < PresenterTestCase
  def schema_name
    "unpublishing"
  end

  test "presents the basic details required to display an unpublishing" do
    unpublishing = schema_item("unpublishing")
    assert_equal unpublishing["schema_name"], presented_item.schema_name
    assert_equal unpublishing["locale"], presented_item.locale
    assert_equal unpublishing["details"]["explanation"], presented_item.explanation

    assert_nil unpublishing["details"]["alternative_url"]
    assert_nil presented_item.alternative_url
  end
end
