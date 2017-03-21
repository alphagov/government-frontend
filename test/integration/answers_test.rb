require 'test_helper'

class AnswerTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('answer')
    assert page.has_text?(@content_item["title"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end
end
