require 'test_helper'

class TakePartTest < ActionDispatch::IntegrationTest
  test "take part pages" do
    setup_and_visit_content_item('take_part')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_govspeak(@content_item["details"]["body"])
  end
end
