require 'test_helper'

class GovernmentNavigationTest < ActionDispatch::IntegrationTest
  test "includes government navigation and sets the correct active item" do
    example_body = get_content_example_by_format_and_name("case_study", "case_study")
    base_path = JSON.parse(example_body).fetch("base_path")
    content_store_has_item(base_path, example_body)

    visit base_path

    assert_has_active_government_navigation("case-studies")
  end

  def assert_has_active_government_navigation(name)
    within shared_component_selector("government_navigation") do
      assert_equal name, JSON.parse(page.text).fetch("active")
    end
  end
end
