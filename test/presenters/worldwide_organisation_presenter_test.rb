require "presenter_test_helper"

class WorldwideOrganisationPresenterTest < PresenterTestCase
  def schema_name
    "worldwide_organisation"
  end

  test "presents the title" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "presents the body" do
    assert_equal schema_item["details"]["body"], presented_item.body
  end
end
