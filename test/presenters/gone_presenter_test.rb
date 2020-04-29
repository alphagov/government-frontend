require "presenter_test_helper"

class GonePresenterTest < PresenterTestCase
  def schema_name
    "gone"
  end

  test "presents the basic details required to display an gone" do
    gone = schema_item("gone")
    assert_equal gone["details"]["explanation"], presented_item.explanation
    assert_equal gone["details"]["alternative_path"], presented_item.alternative_path
  end
end
