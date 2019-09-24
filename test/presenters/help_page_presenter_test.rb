require "presenter_test_helper"

class HelpPagePresenterTest < PresenterTestCase
  def schema_name
    "help_page"
  end

  test "presents the title" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "presents the body" do
    assert_equal schema_item["details"]["body"], presented_item.body
  end
end
