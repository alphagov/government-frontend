require "presenter_test_helper"

class WorldwideOfficePresenterTest < PresenterTestCase
  def schema_name
    "worldwide_office"
  end

  test "#title returns the title of the schema item" do
    assert_equal schema_item["title"], presented_item.title
  end

  test "#body returns the access and opening times of the schema item" do
    assert_equal schema_item["details"]["access_and_opening_times"], presented_item.body
  end
end
